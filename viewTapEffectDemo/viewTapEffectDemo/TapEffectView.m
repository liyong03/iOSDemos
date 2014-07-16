//
//  TapEffectView.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "TapEffectView.h"

@interface TapEffectView()

@property (nonatomic, copy) void(^completionHandler)();

@end

@implementation TapEffectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showEffectWithCompletion:(void(^)())handler {
    CGFloat edge = MIN(self.bounds.size.width, self.bounds.size.height);
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, edge, edge) cornerRadius:edge/2].CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineWidth = 2;
    [self.layer addSublayer:layer];
    layer.bounds = self.bounds;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    layer.transform = CATransform3DMakeScale(2, 2, 1);
    layer.opacity = 1.0;


    static float scaleTime = 0.3;
    static float disappTime = 0.1;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.delegate = self;
    animation.duration = scaleTime;
    animation.fromValue = @(0.01);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    CABasicAnimation* disappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    disappear.delegate = self;
    disappear.duration = disappTime;
    disappear.beginTime = scaleTime;
    disappear.fromValue = @(1);
    disappear.toValue = @(0);
    disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappear.fillMode = kCAFillModeForwards;
    disappear.removedOnCompletion = NO;
    
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ animation, disappear ];
    group.duration = (scaleTime + disappTime);
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [layer addAnimation:group forKey:@"tapEffect"];
    
    self.completionHandler = handler;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.completionHandler)
        self.completionHandler();
    self.completionHandler = nil;
}

@end
