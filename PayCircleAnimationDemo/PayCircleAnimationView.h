//
//  PayCircleView.h
//  TestDemo
//
//  Created by wangjian on 2017/5/4.
//  Copyright © 2017年 com.qhfax. All rights reserved.
// 仿支付宝支付转圈动画

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef  NS_ENUM(NSInteger,PayResult){

    PayResult_Success,//支付成功
    PayResult_Failed,//支付失败
};


@interface PayCircleAnimationView : UIView<CAAnimationDelegate>
{
    //刷新工具
    CADisplayLink *_displayLink;
    //显示圆环
    CAShapeLayer *_animationLayer;
    CAShapeLayer *_rightLayer;//显示✅号
    CAShapeLayer *_errLayer;//显示❎号
    //起始角度
    CGFloat _startAngle;
    //结束角度
    CGFloat _endAngle;
    //当前动画进度
    CGFloat _progress;
}
/**线条颜色*/
@property (nonatomic,retain)UIColor *lineColor;
/**支付结果状态*/
@property (nonatomic,assign)PayResult payResult;
/**开始动画*/
- (void)startAnimation;
/**结束动画*/
- (void)endAnimation;
/**开始绘制结果动画*/
- (void)startResultAnimation;
@end
