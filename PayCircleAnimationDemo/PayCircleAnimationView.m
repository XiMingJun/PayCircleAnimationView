//
//  PayCircleView.m
//  TestDemo
//
//  Created by wangjian on 2017/5/4.
//  Copyright © 2017年 com.qhfax. All rights reserved.
//

#import "PayCircleAnimationView.h"
#define kLineWidth 5 //线条宽度
#define kCircleAnimation_Key @"circleAnimation"//环形动画
#define kCheckAnimation_Key @"checkAnimation" //✅动画
#define kErrorAnimation_Key @"errorAnimation"//❎动画
#define kAnimationTag @"animationTag"//区分不同动画的key
@implementation PayCircleAnimationView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineColor = [UIColor blueColor];

        self.payResult = PayResult_Success;
        
        self.backgroundColor = [UIColor clearColor];
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _animationLayer.position = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0);
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = self.lineColor.CGColor;
        _animationLayer.lineWidth = kLineWidth;
        _animationLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_animationLayer];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = true;
        
        
    }
    return self;
}
- (void)startAnimation{
    _displayLink.paused = NO;
}
-(void)endAnimation{
    _displayLink.paused = YES;
    _progress = 0;
}
-(void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}
-(CGFloat)speed{
    
    if (_endAngle > M_PI) {
        //后半段
        return 0.2/ 60.0f;
    }
    return 1.0/60.0f;
}
-(void)updateAnimationLayer{
    
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - kLineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    _animationLayer.path = path.CGPath;
}
- (void)startResultAnimation{

    [self endAnimation];

    CGFloat radius = _animationLayer.bounds.size.width/2.0f - kLineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    _animationLayer.path = path.CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 1.0;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    circleAnimation.delegate = self;
    [circleAnimation setValue:kCircleAnimation_Key forKey:kAnimationTag];
    [_animationLayer addAnimation:circleAnimation forKey:nil];
    
    
}
/**开始绘制✅动画*/
-(void)startRightAnimation{
    
    CGFloat a = _animationLayer.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
    [path addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
    [path addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.path = path.CGPath;
    _rightLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLayer.strokeColor = self.lineColor.CGColor;
    _rightLayer.lineWidth = kLineWidth;
    _rightLayer.lineCap = kCALineCapRound;
    _rightLayer.lineJoin = kCALineJoinRound;
    [_animationLayer addSublayer:_rightLayer];
    
    CABasicAnimation *rightAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightAnimation.duration = 0.5;
    rightAnimation.fromValue = @(0.0f);
    rightAnimation.toValue = @(1.0f);
    rightAnimation.delegate = self;
    [rightAnimation setValue:kCheckAnimation_Key forKey:kAnimationTag];
    rightAnimation.removedOnCompletion = YES;
    [_rightLayer addAnimation:rightAnimation forKey:nil];
}
/**开始绘制❎动画*/
- (void)startWrongAnimation{

    CGPoint resultCenterPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat resultDotRadius = self.frame.size.width/2;
    CGPoint point1           = CGPointMake(resultCenterPoint.x - resultDotRadius/4*2, resultCenterPoint.y - resultDotRadius/4*2);
    CGPoint point2           = CGPointMake(resultCenterPoint.x + resultDotRadius/4*2, resultCenterPoint.y + resultDotRadius/4*2);
    CGPoint point3           = CGPointMake(resultCenterPoint.x + resultDotRadius/4*2, resultCenterPoint.y - resultDotRadius/4*2);
    CGPoint point4           = CGPointMake(resultCenterPoint.x - resultDotRadius/4*2, resultCenterPoint.y + resultDotRadius/4*2);
    UIBezierPath *errPath    = [UIBezierPath bezierPath];
    [errPath moveToPoint:point1];
    [errPath addLineToPoint:point2];
    [errPath moveToPoint:point3];
    [errPath addLineToPoint:point4];
    
    _errLayer   = [CAShapeLayer layer];
    _errLayer.path               = errPath.CGPath;
    _errLayer.lineWidth        = kLineWidth;
    _errLayer.fillColor           = [UIColor clearColor].CGColor;
    _errLayer.strokeColor     = [self.lineColor CGColor];
    _errLayer.lineCap           = kCALineCapRound;
    _errLayer.lineJoin           = kCALineJoinRound;
    [self.layer addSublayer:_errLayer];
    
    CABasicAnimation *errorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    errorAnimation.duration = 0.5;
    errorAnimation.fromValue = @(0.0f);
    errorAnimation.toValue = @(1.0f);
    errorAnimation.delegate = self;
    [errorAnimation setValue:kErrorAnimation_Key forKey:kAnimationTag];
    errorAnimation.removedOnCompletion = YES;
    [_errLayer addAnimation:errorAnimation forKey:nil];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if ([[anim valueForKey:kAnimationTag] isEqualToString:kCircleAnimation_Key]) {
        switch (self.payResult) {
            case PayResult_Success:
            {
                [self startRightAnimation];

            }
                break;
            case PayResult_Failed:
            {
                 [self startWrongAnimation];
            }
                break;
                
            default:
                break;
        }
    }
    else if ([[anim valueForKey:kAnimationTag] isEqualToString:kCheckAnimation_Key]) {
        NSLog(@"✅动画完成");
    }
    else if ([[anim valueForKey:kAnimationTag] isEqualToString:kErrorAnimation_Key]) {
        NSLog(@"❎绘制完毕");
    }
}
# pragma mark - set/get - 
- (void)setLineColor:(UIColor *)lineColor{

    _lineColor = lineColor;
    _animationLayer.strokeColor = _lineColor.CGColor;
    [self setNeedsDisplay];
    
}
- (void)setPayResult:(PayResult)payResult{
    _payResult = payResult;
}
@end
