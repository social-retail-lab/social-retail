#!/usr/bin/env python3
"""
Migration script: extracts INSERT statements from db_new SQL,
fixes schema differences, and generates INSERT IGNORE statements.
"""

import re
import sys

INPUT_FILE = r"H:\asocial\social-retail\backend\src\main\resources\db_new\social_retail_db.sql"
OUTPUT_FILE = r"H:\asocial\social-retail\backend\src\main\resources\db_new\migrate_output.sql"

# Tables to import (in dependency order)
# Tables to skip: `order`, `order_item`, platform_account_summary (not needed per task)
TABLES_TO_IMPORT = [
    'user',           # 25 rows, IDs 1001-1025 (likely all exist)
    'brand',          # 50 rows, IDs 5001-5050
    'category',       # 50 rows, IDs 1-608
    'merchant',       # 25 rows, IDs 2001-2025
    'merchant_apply', # 25 rows, IDs 4001-4025
    'merchant_qualification', # 25 rows, IDs 3001-3025
    'product',        # 198 rows, IDs 6001-6198
    'sku',            # ~198 rows, IDs 8001-8198
    'product_category_relation', # 198 rows
]

def fix_merchant_insert(line):
    """
    db_new column order: id, user_id, merchant_name, logo, contact_name, contact_phone, 
                          shop_address, business_hours, introduction, create_time, status
    Current DB order:    id, user_id, merchant_name, logo, contact_name, contact_phone,
                          shop_address, status, business_hours, introduction, create_time
    Fix: use explicit column names matching current DB order.
    """
    # Extract values between VALUES ( and );
    m = re.match(r"INSERT INTO `merchant` VALUES \((.*)\);", line.strip())
    if not m:
        return line
    values_str = m.group(1)
    # Parse values (handle quoted strings with commas)
    values = parse_values(values_str)
    if len(values) != 11:
        print(f"WARNING: merchant row has {len(values)} values, expected 11: {line[:80]}")
        return line
    
    # Reorder for current DB:
    # db_new order: [0]id, [1]user_id, [2]name, [3]logo, [4]contact_name, [5]contact_phone,
    #               [6]shop_address, [7]business_hours, [8]introduction, [9]create_time, [10]status
    # Current order: id, user_id, merchant_name, logo, contact_name, contact_phone,
    #                shop_address, status, business_hours, introduction, create_time
    id_val = values[0]
    user_id = values[1]
    name = values[2]
    logo = values[3]
    contact_name = values[4]
    contact_phone = values[5]
    shop_address = values[6]
    business_hours = values[7]
    introduction = values[8]
    create_time = values[9]
    status = values[10]
    
    return (f"INSERT IGNORE INTO `merchant` "
            f"(`id`, `user_id`, `merchant_name`, `logo`, `contact_name`, `contact_phone`, "
            f"`shop_address`, `status`, `business_hours`, `introduction`, `create_time`) "
            f"VALUES ({id_val}, {user_id}, {name}, {logo}, {contact_name}, {contact_phone}, "
            f"{shop_address}, {status}, {business_hours}, {introduction}, {create_time});")


def fix_product_insert(line):
    """
    db_new product: 16 cols (no force_off_shelf)
    Current product: 17 cols (force_off_shelf at position 10, between status and audit_status)
    
    db_new order: id, brand_id, merchant_id, title, sub_title, main_image, detail_desc, 
                  detail_images, sale_type, status, audit_status, audit_remark, 
                  audit_time, create_time, update_time, sold_count
    Current order: id, brand_id, merchant_id, title, sub_title, main_image, detail_desc,
                   detail_images, sale_type, status, force_off_shelf, audit_status, 
                   audit_remark, audit_time, create_time, update_time, sold_count
    Fix: add force_off_shelf=0 after status
    """
    m = re.match(r"INSERT INTO `product` VALUES \((.*)\);", line.strip())
    if not m:
        return line
    values_str = m.group(1)
    values = parse_values(values_str)
    if len(values) != 16:
        print(f"WARNING: product row has {len(values)} values, expected 16: {line[:80]}")
        return line
    
    # Insert 0 for force_off_shelf after status (index 9)
    values.insert(10, '0')
    return "INSERT IGNORE INTO `product` VALUES (" + ", ".join(values) + ");"


def parse_values(s):
    """Parse a comma-separated list of SQL values, handling quoted strings."""
    values = []
    current = []
    in_quotes = False
    quote_char = None
    i = 0
    while i < len(s):
        c = s[i]
        if not in_quotes:
            if c == "'" or c == '"':
                in_quotes = True
                quote_char = c
                current.append(c)
            elif c == ',':
                values.append(''.join(current).strip())
                current = []
            else:
                current.append(c)
        else:
            if c == '\\':
                current.append(c)
                if i + 1 < len(s):
                    i += 1
                    current.append(s[i])
            elif c == quote_char:
                current.append(c)
                # Check if next char is also quote (escaped quote)
                if i + 1 < len(s) and s[i+1] == quote_char:
                    i += 1
                    current.append(s[i])
                else:
                    in_quotes = False
            else:
                current.append(c)
        i += 1
    if current:
        values.append(''.join(current).strip())
    return values


def main():
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    
    output_lines = [
        "-- Migration script generated from db_new/social_retail_db.sql",
        "-- Only INSERT IGNORE statements for new data",
        "SET NAMES utf8mb4;",
        "SET FOREIGN_KEY_CHECKS = 0;",
        "",
    ]
    
    current_table = None
    in_records = False
    
    for line in lines:
        stripped = line.strip()
        
        # Detect table section
        if stripped.startswith('-- Records of '):
            table_name = stripped[len('-- Records of '):].strip()
            current_table = table_name
            in_records = True
            continue
        
        # Detect next table structure
        if stripped.startswith('-- Table structure for '):
            in_records = False
            continue
        
        if stripped.startswith('DROP TABLE') or stripped.startswith('CREATE TABLE'):
            in_records = False
            continue
        
        if not in_records:
            continue
        
        if not stripped.startswith('INSERT INTO '):
            continue
        
        # Process INSERT statement
        if current_table not in TABLES_TO_IMPORT:
            continue
        
        new_line = stripped
        
        # Fix merchant column order
        if current_table == 'merchant':
            new_line = fix_merchant_insert(stripped)
        # Fix product: add force_off_shelf
        elif current_table == 'product':
            new_line = fix_product_insert(stripped)
        else:
            # For other tables, just change INSERT to INSERT IGNORE
            new_line = stripped.replace('INSERT INTO ', 'INSERT IGNORE INTO ', 1)
        
        output_lines.append(new_line)
    
    output_lines.append("")
    output_lines.append("SET FOREIGN_KEY_CHECKS = 1;")
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output_lines))
    
    print(f"Migration SQL written to: {OUTPUT_FILE}")
    print(f"Total INSERT lines: {len(output_lines) - 5}")

if __name__ == '__main__':
    main()
