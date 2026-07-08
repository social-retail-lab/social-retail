-- =====================================================
-- update_social_retail_0707_v10_db.sql
-- 1. 每个商家都有对应用户账号
-- 2. 修改用户昵称为网名风格
-- 3. 头像统一为 /static/avatar/1001.jpg
-- 4. 部分用户使用"用户+八位随机字符"默认用户名
-- =====================================================

USE social_retail_db;

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- Part A: 创建新用户（给没有账号的商家）
-- 20 个商家缺少用户：2011,2012,2014,2016,2017,2018,2020,2022,2024,2025,2026-2035
-- =====================================================

INSERT INTO `user` (`id`, `phone`, `nickname`, `password`, `avatar`, `sex`, `status`) VALUES
(1026, '17782224525', '初夏微暖', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1027, '17782224526', '用户Jt3Pm6Qw', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1028, '17782224527', '旧城半夏', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1029, '17782224528', '用户Qk7Vn2Hb', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1030, '17782224529', '鹿半森', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1031, '17782224530', '用户Rs4Xd8Ky', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1032, '17782224531', '薄暮凉年', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1033, '17782224532', '用户Wm9Tf1Lc', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1034, '17782224533', '长街听风', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1035, '17782224534', '用户Gp5Bn3Zv', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1036, '17782224535', '梦醒伤人心', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1037, '17782224536', '用户Ua8Ez4Rj', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1038, '17782224537', '浪荡不羁', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1039, '17782224538', '用户Hw6Ld1Np', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1040, '17782224539', '薄荷凉心', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1041, '17782224540', '用户Cb2Yv7Mk', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1042, '17782224541', '逆光奔跑', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1),
(1043, '17782224542', '用户Fs8Ka4Qu', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1044, '17782224543', '倾听雨落', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 0, 1),
(1045, '17782224544', '用户Dx9Zr5Ef', 'e18ca020a37ff8c10fc1166f1de931ef', '/static/avatar/1001.jpg', 1, 1);

SELECT '✅ 新增20个用户账号完成' AS result;

-- =====================================================
-- Part B: 修改已有用户昵称为网名风格
-- =====================================================

UPDATE `user` SET `nickname` = '柠檬不萌', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1001;
UPDATE `user` SET `nickname` = '清风徐来', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1002;
UPDATE `user` SET `nickname` = '夏日微凉', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1003;
UPDATE `user` SET `nickname` = '星空幻想', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1004;
UPDATE `user` SET `nickname` = '用户aB3xKp7Q', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1005;
UPDATE `user` SET `nickname` = '用户mN9qW4vL', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1006;
UPDATE `user` SET `nickname` = '糖心小铺', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1007;
UPDATE `user` SET `nickname` = '用户Rn2Jh8kT', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1008;
UPDATE `user` SET `nickname` = '海风轻语', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1009;
UPDATE `user` SET `nickname` = '用户Fc6Vt3Zw', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1010;
UPDATE `user` SET `nickname` = '棉花糖巷', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1011;
UPDATE `user` SET `nickname` = '用户Ds7Xp1Ny', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1012;
UPDATE `user` SET `nickname` = '云端漫步', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1013;
UPDATE `user` SET `nickname` = '墨色时光', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1014;
UPDATE `user` SET `nickname` = '用户Hm5Kq9Rb', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1015;
UPDATE `user` SET `nickname` = '北城以南', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1016;
UPDATE `user` SET `nickname` = '用户Pw3Sj6Ua', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1017;
UPDATE `user` SET `nickname` = '花开彼岸', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1018;
UPDATE `user` SET `nickname` = '用户Lt8Vc4QW', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1019;
UPDATE `user` SET `nickname` = '暖阳微光', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1020;
UPDATE `user` SET `nickname` = '用户Ez2Rn5Bf', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1021;
UPDATE `user` SET `nickname` = '夜色微醺', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1022;
UPDATE `user` SET `nickname` = '用户Gn7Xy1Bw', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1023;
UPDATE `user` SET `nickname` = '山海皆可', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1024;
UPDATE `user` SET `nickname` = '用户Jk4Md9Qr', `avatar` = '/static/avatar/1001.jpg' WHERE `id` = 1025;

SELECT '✅ 已更新所有已有用户昵称和头像' AS result;

-- =====================================================
-- Part C: 将新用户绑定到对应商家
-- =====================================================

UPDATE `merchant` SET `user_id` = 1026 WHERE `id` = 2011 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1027 WHERE `id` = 2012 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1028 WHERE `id` = 2014 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1029 WHERE `id` = 2016 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1030 WHERE `id` = 2017 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1031 WHERE `id` = 2018 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1032 WHERE `id` = 2020 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1033 WHERE `id` = 2022 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1034 WHERE `id` = 2024 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1035 WHERE `id` = 2025 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1036 WHERE `id` = 2026 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1037 WHERE `id` = 2027 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1038 WHERE `id` = 2028 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1039 WHERE `id` = 2029 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1040 WHERE `id` = 2030 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1041 WHERE `id` = 2031 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1042 WHERE `id` = 2032 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1043 WHERE `id` = 2033 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1044 WHERE `id` = 2034 AND `user_id` IS NULL;
UPDATE `merchant` SET `user_id` = 1045 WHERE `id` = 2035 AND `user_id` IS NULL;

SELECT '✅ 20个商家已绑定用户账号' AS result;

-- =====================================================
-- Part D: 验证
-- =====================================================

-- D1. 所有商家账号绑定情况
SELECT m.id, m.merchant_name, m.user_id, u.nickname
FROM `merchant` m
LEFT JOIN `user` u ON m.user_id = u.id
ORDER BY m.id;

-- D2. 所有用户昵称及头像
SELECT id, phone, nickname, avatar, status FROM `user` ORDER BY id;

SET FOREIGN_KEY_CHECKS = 1;
