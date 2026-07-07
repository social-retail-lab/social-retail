<style scoped>
.product-page {
  width: 95%;
  margin: 30px auto;
}
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
h2 {
  color: #2D2D2D;
}
.add-btn {
  padding: 8px 16px;
  background: #E66100;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
input, select, button {
  padding: 7px 10px;
  border-radius: 4px;
  border: 1px solid #ddd;
}
table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
}
table th, table td {
  padding: 8px;
  text-align: center;
  border: 1px solid #eee;
  color: #595959;
}
table th {
  background: #E5E6EB;
  font-weight: 600;
  font-size: 15px;
}
.page-wrap {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-top: 10px;
  color: #595959;
}
/* 弹窗 */
.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
}
.dialog {
  width: 600px;
  background: white;
  padding: 24px;
  border-radius: 8px;
}
.form-item {
  margin-bottom: 14px;
}
.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 14px;
}
.form-row .item {
  flex: 1;
}
label {
  display: block;
  margin-bottom: 5px;
  color: #595959;
}
input {
  width: 100%;
  box-sizing: border-box;
  padding: 9px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.btns {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}
.save {
  background: #E66100;
  color: white;
  border: none;
  cursor: pointer;
}
</style>