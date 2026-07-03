-- KEYS[1]: 秒杀库存键，例如 seckill:stock:{activityId}:{skuId}
-- KEYS[2]: 用户抢购数量Hash，例如 seckill:users:{activityId}:{skuId}
-- ARGV[1]: 用户ID
-- ARGV[2]: 本次购买数量，默认1
-- ARGV[3]: 每人限购数量，默认1
-- 返回值：>=0 扣减后的剩余库存；-1 库存不足/未初始化；-2 用户重复下单

local quantity = tonumber(ARGV[2]) or 1
local limit = tonumber(ARGV[3]) or 1
local bought = tonumber(redis.call('HGET', KEYS[2], ARGV[1])) or 0

if quantity <= 0 or bought + quantity > limit then
    return -2
end

local stock = tonumber(redis.call('GET', KEYS[1]))
if stock == nil or stock < quantity then
    return -1
end

local remaining = redis.call('DECRBY', KEYS[1], quantity)
redis.call('HINCRBY', KEYS[2], ARGV[1], quantity)
return remaining
