//
//  ShareButtonView.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ShareButtonView.h"
#import "Evaluate.h"

@interface ShareButtonView()

@property (nonatomic, strong, readwrite) UIImage* shareIcon;
@property (nonatomic, copy, readwrite) NSString* shareTitle;

@end

@implementation ShareButtonView {
    UIImageView*    _iconView;
    CAShapeLayer*   _iconLayer;
    UILabel*        _titleLabel;
    UILabel*        _doneLabel;
    UILabel*        _doneMarkLabel;
}

- (id)initWithIcon:(UIImage*)icon andTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        // Initialization code
        _shareIcon = icon;
        _shareTitle = title;
        [self _setup];
    }
    return self;
}

- (void)_setup {
    
    _iconView = [[UIImageView alloc] initWithImage:_shareIcon];
    _doneMarkLabel = [[UILabel alloc] init];
    _doneMarkLabel.text = @"✔︎";
    _doneMarkLabel.textColor = [UIColor grayColor];
    _doneMarkLabel.font = [UIFont systemFontOfSize:40];
    _doneMarkLabel.textAlignment = NSTextAlignmentCenter;
    _doneMarkLabel.hidden = YES;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _shareTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel = [[UILabel alloc] init];
    _doneLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel.text = @"done!";
    _doneLabel.hidden = YES;
    
    [self addSubview:_iconView];
    [self addSubview:_doneMarkLabel];
    [self addSubview:_titleLabel];
    [self addSubview:_doneLabel];
    
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    _iconLayer.strokeColor = [UIColor whiteColor].CGColor;
    _iconLayer.lineWidth = 2;
    _iconLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _iconLayer.opacity = 1.0;
    [self.layer insertSublayer:_iconLayer above:_iconView.layer];

}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    CGFloat labelHeight = 15;
    _titleLabel.frame = CGRectMake(0, frame.size.height - labelHeight, frame.size.width, labelHeight);
    _doneLabel.frame = _titleLabel.frame;
    
    frame.size.height -= labelHeight;
    CGFloat wid = MIN(frame.size.width, frame.size.height);
    CGRect square = CGRectMake((frame.size.width-wid)/2,
                               (frame.size.height-wid)/2,
                               wid, wid);
    square = CGRectInset(square, 10, 10);
    _iconView.frame = square;
    _doneMarkLabel.frame = _iconView.frame;
    
    _iconLayer.bounds = _iconView.bounds;
    _iconLayer.position = _iconView.center;
    _iconLayer.path = [UIBezierPath bezierPathWithRoundedRect:_iconLayer.bounds cornerRadius:_iconLayer.bounds.size.width/2].CGPath;
}

- (void)animateToDone {
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = 0.5;
    animation.fromValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    animation.toValue = (id)[UIColor whiteColor].CGColor;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [_iconLayer addAnimation:animation forKey:@"done"];
    
    _doneMarkLabel.hidden = NO;
    _doneMarkLabel.layer.opacity = 0;
    CABasicAnimation* doneappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    doneappear.duration = 0.5;
    doneappear.beginTime = 0.0;
    doneappear.fromValue = @(0);
    doneappear.toValue = @(1);
    doneappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    doneappear.fillMode = kCAFillModeForwards;
    doneappear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    moveUp3.duration = 0.5;
    moveUp3.beginTime = 0.0;
    moveUp3.fromValue = @(1.2);
    moveUp3.toValue = @(1);
    moveUp3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp3.fillMode = kCAFillModeForwards;
    moveUp3.removedOnCompletion = NO;
    
    CAAnimationGroup* doneMarkAnimation = [[CAAnimationGroup alloc] init];
    doneMarkAnimation.animations = @[ doneappear, moveUp3 ];
    doneMarkAnimation.duration = 0.5;
    doneMarkAnimation.delegate = self;
    doneMarkAnimation.fillMode = kCAFillModeForwards;
    doneMarkAnimation.removedOnCompletion = NO;
    [_doneMarkLabel.layer addAnimation:doneMarkAnimation forKey:@"doneAnimation"];
    
    
    CABasicAnimation* disappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    disappear.duration = 0.2;
    disappear.beginTime = 0.3;
    disappear.fromValue = @(1);
    disappear.toValue = @(0);
    disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappear.fillMode = kCAFillModeForwards;
    disappear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveUp.duration = 0.2;
    moveUp.beginTime = 0.3;
    moveUp.fromValue = @(_titleLabel.layer.position.y);
    moveUp.toValue = @(_titleLabel.layer.position.y-20);
    moveUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp.fillMode = kCAFillModeForwards;
    moveUp.removedOnCompletion = NO;
    
    CAAnimationGroup* titleAnimation = [[CAAnimationGroup alloc] init];
    titleAnimation.animations = @[ disappear, moveUp ];
    titleAnimation.duration = 0.5;
    titleAnimation.delegate = self;
    titleAnimation.fillMode = kCAFillModeForwards;
    titleAnimation.removedOnCompletion = NO;
    
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"moveup"];
    
    _doneLabel.hidden = NO;
    _doneLabel.layer.opacity = 0;
    CABasicAnimation* appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.duration = 0.2;
    appear.beginTime = 0.3;
    appear.fromValue = @(0);
    appear.toValue = @(1);
    appear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    appear.fillMode = kCAFillModeForwards;
    appear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveUp2.duration = 0.2;
    moveUp2.beginTime = 0.3;
    moveUp2.fromValue = @(_doneLabel.layer.position.y+20);
    moveUp2.toValue = @(_doneLabel.layer.position.y);
    moveUp2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp2.fillMode = kCAFillModeForwards;
    moveUp2.removedOnCompletion = NO;
    
    CAAnimationGroup* doneAnimation = [[CAAnimationGroup alloc] init];
    doneAnimation.animations = @[ appear, moveUp2 ];
    doneAnimation.duration = 0.5;
    doneAnimation.delegate = self;
    doneAnimation.fillMode = kCAFillModeForwards;
    doneAnimation.removedOnCompletion = NO;
    [_doneLabel.layer addAnimation:doneAnimation forKey:@"doneAnimation"];
}

- (void) showAnimation {
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.values = [YLSPringAnimation calculateKeyFramesFromeStartValue:0.01 endValue:1.0 interstitialSteps:10];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [self.layer addAnimation:animation forKey:@"showAnimation"];
}

@end
