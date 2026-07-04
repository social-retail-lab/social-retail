use `social_retail_db`;
-- 会员中心上线迁移：保证每个用户只有一份会员账户，并补齐历史用户。
ALTER TABLE `member`
  MODIFY `user_id` BIGINT NOT NULL,
  MODIFY `member_level` TINYINT NOT NULL DEFAULT 1,
  MODIFY `points_balance` INT NOT NULL DEFAULT 0,
  MODIFY `growth_value` INT NOT NULL DEFAULT 0,
  ADD UNIQUE KEY `uk_member_user` (`user_id`);
