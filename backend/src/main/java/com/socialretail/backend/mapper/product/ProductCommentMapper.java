package com.socialretail.backend.mapper.product;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.entity.product.ProductComment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProductCommentMapper extends BaseMapper<ProductComment> {

    IPage<CommentViewRow> selectMyComments(Page<CommentViewRow> page,
                                            @Param("userId") Long userId);

    IPage<CommentViewRow> selectProductComments(Page<CommentViewRow> page,
                                                 @Param("productId") Long productId,
                                                 @Param("score") Integer score);

    CommentViewRow selectCommentDetail(@Param("commentId") Long commentId);

    ProductCommentStatisticsRow selectProductCommentStatistics(
            @Param("productId") Long productId);

    List<CommentViewRow> selectLatestProductComments(
            @Param("productId") Long productId,
            @Param("limit") int limit);
}
