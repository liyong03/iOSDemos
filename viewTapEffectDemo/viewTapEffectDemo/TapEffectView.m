//
//  TapEffectView.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "TapEffectView.h"
#import "JNWSpringAnimation.h"

@protocol Evaluate

- (double)evaluateAt:(double)position;

@end

@interface BezierEvaluator : NSObject <Evaluate>
{
	double firstControlPoint;
	double secondControlPoint;
}

- (id)initWithFirst:(double)newFirst second:(double)newSecond;

@end

@interface ExponentialDecayEvaluator : NSObject <Evaluate>
{
	double coeff;
	double offset;
	double scale;
}

- (id)initWithCoefficient:(double)newCoefficient;

@end

@interface SecondOrderResponseEvaluator : NSObject <Evaluate>
{
	double omega;
	double zeta;
}

- (id)initWithOmega:(double)newOmega zeta:(double)newZeta;

@end


@implementation BezierEvaluator

- (id)initWithFirst:(double)newFirst second:(double)newSecond
{
	self = [super init];
	if (self != nil)
	{
		firstControlPoint = newFirst;
		secondControlPoint = newSecond;
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	return
    // (1 - position) * (1 - position) * (1 - position) * 0.0 +
    3 * position * (1 - position) * (1 - position) * firstControlPoint +
    3 * position * position * (1 - position) * secondControlPoint +
    position * position * position * 1.0;
}

@end

@implementation ExponentialDecayEvaluator

- (id)initWithCoefficient:(double)newCoeff
{
	self = [super init];
	if (self != nil)
	{
		coeff = newCoeff;
		offset = exp(-coeff);
		scale = 1.0 / (1.0 - offset);
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	return 1.0 - scale * (exp(position * -coeff) - offset);
}

@end

@implementation SecondOrderResponseEvaluator

- (id)initWithOmega:(double)newOmega zeta:(double)newZeta
{
	self = [super init];
	if (self != nil)
	{
		omega = newOmega;
		zeta = newZeta;
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	double beta = sqrt(1 - zeta * zeta);
	double phi = atan(beta / zeta);
	double result = 1.0 + -1.0 / beta * exp(-zeta * omega * position) * sin(beta * omega * position + phi);
	return result;
}

@end


@interface TapEffectView()

@property (nonatomic, copy) void(^completionHandler)();

@end

@implementation TapEffectView {
    CALayer* _layer;
}

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
    if (self.completionHandler)
        self.completionHandler();
    self.completionHandler = nil;
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

- (void)dismissEnlargeEffect:(void(^)())handler {
    [_layer removeAllAnimations];
    handler();
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
