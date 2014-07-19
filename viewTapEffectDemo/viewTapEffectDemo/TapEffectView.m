//
//  TapEffectView.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "TapEffectView.h"
#import "JNWSpringAnimation.h"
#import "Evaluate.h"

@interface TapEffectView()

@property (nonatomic, copy) void(^completionHandler)();

@end

@implementation TapEffectView {
    CALayer* _layer;
    CAShapeLayer* _btnLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btnLayer = [CAShapeLayer layer];
        _btnLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
        _btnLayer.strokeColor = [UIColor whiteColor].CGColor;
        _btnLayer.lineWidth = 2;
        [self.layer addSublayer:_btnLayer];
        _btnLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _btnLayer.opacity = 1.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect = CGRectInset(rect, 10, 10);
    _btnLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _btnLayer.bounds = rect;
    _btnLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
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
    _layer = layer;
    
    
    static float scaleTime = 0.6;
    static float disappTime = 0.1;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //    animation.delegate = self;
    animation.duration = scaleTime;
    //    animation.fromValue = @(0.01);
    //    animation.toValue = @(1);
    animation.values = [self calculateKeyFramesFromeStartValue:0.01 endValue:1.0 interstitialSteps:10];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
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
    if (flag) {
        if (self.completionHandler)
            self.completionHandler();
        self.completionHandler = nil;
    }
}

- (void)showCircleEffectWithCompletion:(void(^)())handler {
    CGFloat edge = MIN(self.bounds.size.width, self.bounds.size.height);
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, edge, edge) cornerRadius:edge/2].CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 2;
    layer.lineCap= kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:layer];
    layer.bounds = self.bounds;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    layer.opacity = 1.0;
    _layer = layer;
    
    
    static float scaleTime = 1.0;
    static float disappTime = 0.1;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    animation.delegate = self;
    animation.duration = scaleTime;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    
    
    CABasicAnimation* disappear = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    disappear.duration = disappTime;
    disappear.beginTime = scaleTime;
    disappear.fromValue = @(1);
    disappear.toValue = @(0.01);
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
    
    
    CABasicAnimation* disappear2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    disappear2.fromValue = @(1);
    disappear2.toValue = @(0.01);
    //disappear2.delegate = self;
    disappear2.fillMode = kCAFillModeForwards;
    disappear2.removedOnCompletion = NO;
    disappear2.duration = disappTime;
    disappear2.beginTime = scaleTime;
    
    CAAnimationGroup *group2 = [[CAAnimationGroup alloc] init];
    group2.animations = @[ disappear2 ];
    group2.duration = (scaleTime + disappTime);
    group2.delegate = self;
    group2.fillMode = kCAFillModeForwards;
    group2.removedOnCompletion = NO;
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((scaleTime-0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_btnLayer addAnimation:group2 forKey:@"tapEffect"];
    //});
    
    self.completionHandler = handler;
}

- (void)showEnlargeEffect {
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
    layer.transform = CATransform3DMakeScale(1, 1, 1);
    layer.opacity = 1.0;
    _layer = layer;
    
    
    static float scaleTime = INT_MAX;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = scaleTime;
    animation.fromValue = @(0.01);
    animation.toValue = @(1+2.0*scaleTime);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [layer addAnimation:animation forKey:@"tapEffect"];
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)dismissEnlargeEffect:(void(^)())handler {
    //[_layer removeAllAnimations];
    //[_btnLayer removeAllAnimations];
    [self pauseLayer:_layer];
    [self pauseLayer:_btnLayer];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        handler();
    }];
}

- (NSMutableArray*)calculateKeyFramesFromeStartValue:(double)startValue
                                            endValue:(double)endValue
                                   interstitialSteps:(NSUInteger)steps
{
    NSUInteger count = steps + 2;
    SecondOrderResponseEvaluator* evaluator = [[SecondOrderResponseEvaluator alloc] initWithOmega:20.0 zeta:0.4];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
    
    double progress = 0.0;
    double increment = 1.0 / (double)(count - 1);
    NSUInteger i;
    for (i = 0; i < count; i++)
    {
        double value =
        startValue +
        [evaluator evaluateAt:progress] * (endValue - startValue);
        [valueArray addObject:[NSNumber numberWithDouble:value]];
        
        progress += increment;
    }
    
    return valueArray;
}

@end
