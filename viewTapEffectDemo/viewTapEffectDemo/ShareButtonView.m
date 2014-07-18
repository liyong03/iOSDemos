//
//  ShareButtonView.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ShareButtonView.h"

@interface ShareButtonView()

@property (nonatomic, strong, readwrite) UIImage* shareIcon;
@property (nonatomic, copy, readwrite) NSString* shareTitle;

@end

@implementation ShareButtonView {
    UIImageView*    _iconView;
    CAShapeLayer*   _iconLayer;
    UILabel*        _titleLabel;
    UILabel*        _doneLabel;
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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _shareTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel = [[UILabel alloc] init];
    
    [self addSubview:_iconView];
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
    
    _iconLayer.bounds = _iconView.bounds;
    _iconLayer.position = _iconView.center;
    _iconLayer.path = [UIBezierPath bezierPathWithRoundedRect:_iconLayer.bounds cornerRadius:_iconLayer.bounds.size.width/2].CGPath;
}

- (void)animateToDone {
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = 0.3;
    animation.fromValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    animation.toValue = (id)[UIColor whiteColor].CGColor;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [_iconLayer addAnimation:animation forKey:@"done"];
}

@end
