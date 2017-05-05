//
//  ViewController.m
//  PayCircleAnimationView
//
//  Created by wangjian on 2017/5/5.
//  Copyright © 2017年 com.qhfax. All rights reserved.
//

#import "ViewController.h"
#import "PayCircleAnimationView.h"
@interface ViewController ()
{
    PayCircleAnimationView *_circleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
    
    CGFloat circleWidth = 120;
    CGFloat circleHeight = 120;
    
    _circleView = [[PayCircleAnimationView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - circleWidth)/2, 50, circleWidth, circleHeight)];
    _circleView.lineColor = [UIColor blueColor];
    [self.view addSubview:_circleView];
    [_circleView startAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_circleView startResultAnimation];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
