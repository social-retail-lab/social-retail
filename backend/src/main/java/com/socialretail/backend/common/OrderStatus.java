package com.socialretail.backend.common;

/**
 * 订单状态码（统一常量，用户端、商家端、管理端共用）
 */
public final class OrderStatus {

    private OrderStatus() {
    }

    /** 待支付 */
    public static final int WAIT_PAY = 0;

    /** 待接单（已支付，等待商家接单） */
    public static final int WAIT_ACCEPT = 1;

    /** 已接单（商家已接单） */
    public static final int ACCEPTED = 2;

    /** 进行中（配送→配送中，自提→待自提） */
    public static final int IN_PROGRESS = 3;

    /** 已完成 */
    public static final int COMPLETED = 4;

    /** 已取消 */
    public static final int CANCELLED = 5;

    /** 已关闭 */
    public static final int CLOSED = 6;

    /** 配送 */
    public static final int DELIVERY = 1;

    /** 自提 */
    public static final int PICKUP = 2;

    /**
     * 获取状态中文文本（用户端视角）
     */
    public static String userStatusText(Integer status, Integer deliveryType) {
        if (status == null) return "未知";
        switch (status) {
            case WAIT_PAY:     return "待支付";
            case WAIT_ACCEPT:  return "待处理";
            case ACCEPTED:     return "待处理";
            case IN_PROGRESS:
                return (deliveryType != null && deliveryType == PICKUP) ? "待自提" : "配送中";
            case COMPLETED:    return "已完成";
            case CANCELLED:    return "已取消";
            case CLOSED:       return "已关闭";
            default:           return "未知";
        }
    }

    /**
     * 获取状态英文文本（用户端 API）
     */
    public static String userStatusCode(Integer status) {
        if (status == null) return "UNKNOWN";
        switch (status) {
            case WAIT_PAY:     return "WAIT_PAY";
            case WAIT_ACCEPT:  return "WAIT_ACCEPT";
            case ACCEPTED:     return "ACCEPTED";
            case IN_PROGRESS:  return "IN_PROGRESS";
            case COMPLETED:    return "COMPLETED";
            case CANCELLED:    return "CANCELLED";
            case CLOSED:       return "CLOSED";
            default:           return "UNKNOWN";
        }
    }

    /**
     * 获取状态中文文本（商家/管理端视角）
     */
    public static String merchantStatusText(Integer status, Integer deliveryType) {
        if (status == null) return "";
        switch (status) {
            case WAIT_PAY:     return "待支付";
            case WAIT_ACCEPT:  return "待接单";
            case ACCEPTED:     return "已接单";
            case IN_PROGRESS:
                return (deliveryType != null && deliveryType == PICKUP) ? "待自提" : "配送中";
            case COMPLETED:    return "已完成";
            case CANCELLED:    return "已取消";
            case CLOSED:       return "已关闭";
            default:           return "";
        }
    }

    /**
     * 支付完成后，根据配送方式返回下一状态
     */
    public static int nextStatusAfterPay(Integer deliveryType) {
        // 统一进入"待接单"
        return WAIT_ACCEPT;
    }
}
