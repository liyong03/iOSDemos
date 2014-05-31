//
//  ViewController.m
//  CALayerDemo
//
//  Created by Yong Li on 5/31/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.colors = @[
                        (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:1.0].CGColor,
                        (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.2].CGColor,
                        (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:1.0].CGColor];
    
    gradient.startPoint = CGPointMake(0.0f, 0.0f);
    gradient.endPoint = CGPointMake(1.f, 1.0f);
    gradient.anchorPoint = CGPointMake(0, 0);
    gradient.frame = CGRectMake(0, -100, 100, 200);
    
    CALayer* layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.contents = (__bridge id)[UIImage imageNamed:@"evernote"].CGImage;
    layer.mask = gradient;
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation* move = [CABasicAnimation animationWithKeyPath:@"position.y"];
    move.fromValue = @(-100);
    move.toValue = @(0);
    move.duration = 1;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation* move2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    move2.fromValue = @(0);
    move2.toValue = @(-100);
    move2.duration = 1;
    move2.beginTime = 1;
    move2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ move, move2];
    group.duration = 2;
    group.repeatCount = HUGE_VALF;
    
    [gradient addAnimation:group forKey:@"slide"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
