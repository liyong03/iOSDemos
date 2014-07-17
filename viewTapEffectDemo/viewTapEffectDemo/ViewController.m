//
//  ViewController.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "TapEffectView.h"
#import <objc/runtime.h>


@interface YLView : UIView

@end

@implementation YLView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.multipleTouchEnabled = YES;
    }
    return self;
}

static TapEffectView* _effectView = nil;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touched %lu!", (unsigned long)touches.count);
    for (UITouch* touch in [[touches objectEnumerator] allObjects] ) {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            TapEffectView* effectView = [[TapEffectView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            effectView.center = touchPoint;
            [self addSubview:effectView];
            [effectView showEffectWithCompletion:^{
                [effectView removeFromSuperview];
            }];
//            [effectView showEnlargeEffect];
//            _effectView = effectView;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"moved!");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"End!");
//    [_effectView dismissEnlargeEffect:^{
//        [_effectView removeFromSuperview];
//    }];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"cancelled!");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    self.view = [[YLView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
