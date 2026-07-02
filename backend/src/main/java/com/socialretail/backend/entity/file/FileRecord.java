package com.socialretail.backend.entity.file;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("file_record")
public class FileRecord {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private Long ownerUserId;
    private String uploadType;
    private Long businessId;
    private String originalName;
    private String storedPath;
    private Long fileSize;
    private String contentType;
    private LocalDateTime createTime;
    private Integer isDeleted;
}
