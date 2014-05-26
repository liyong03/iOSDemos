//
//  YLViewController.m
//  PopDemo
//
//  Created by Yong Li on 14-5-4.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import "YLViewController.h"
#import <pop/POPSpringAnimation.h>
#import <pop/POPBasicAnimation.h>
#import <pop/POPDecayAnimation.h>

@interface YLViewController ()

@end

@implementation YLViewController {
    UIImageView *_springView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _springView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_springView];
    _springView.backgroundColor = [UIColor greenColor];
    
    UITapGestureRecognizer *gestureForSpring = [[UITapGestureRecognizer alloc] init];
    [gestureForSpring addTarget:self action:@selector(changeSize:)];
    [self.view addGestureRecognizer:gestureForSpring];
}

- (void)changeSize:(UITapGestureRecognizer*)tap{
    
    //用POPSpringAnimation 让viewBlue实现弹性放大缩小的效果
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    CGRect rect = _springView.frame;
    if (rect.size.width==100) {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    }
    else{
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
    }
    
    //springAnimation.duration = 0.8f;
    //弹性值
    springAnimation.springBounciness = 10.0;
    //弹性速度
    springAnimation.springSpeed = 5.0;
    
    springAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    
    [_springView.layer pop_addAnimation:springAnimation forKey:@"changesize"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
