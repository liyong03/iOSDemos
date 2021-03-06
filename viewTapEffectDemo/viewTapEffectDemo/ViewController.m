//
//  ViewController.m
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "TapEffectView.h"
#import "ShareButtonView.h"
#import <objc/runtime.h>
#import <math.h>


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
    //for (UITouch* touch in [[touches objectEnumerator] allObjects] )
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            
            UIImage* icon = [UIImage imageNamed:@"pinterest"];
            NSString* title = @"Pinterest";
            
            UIImage* instaIcon = [UIImage imageNamed:@"instagram"];
            UIImage* facebook = [UIImage imageNamed:@"facebook"];
            
            TapEffectView* effectView = [[TapEffectView alloc] initWithShareIcons:@[facebook,instaIcon,icon] andTitles:@[@"Facebook", @"instagram", title]];
            effectView.center = touchPoint;
            [self addSubview:effectView];
            [effectView showCircleEffectWithCompletion:^{
                [effectView removeFromSuperview];
            }];
//            [effectView showEnlargeEffect];
            _effectView = effectView;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:_effectView];
            [_effectView moveTo:touchPoint];
            
            NSLog(@"moved to %@", NSStringFromCGPoint(touchPoint));
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"End!");
    [_effectView dismissEnlargeEffect:^{
        [_effectView removeFromSuperview];
    }];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"cancelled!");
}

@end

@interface ViewController ()

@end

@implementation ViewController {
    ShareButtonView* _shareButton;
    
    UIButton* _showBtn;
    UIButton* _playBtn;
    UIButton* _selectBtn;
}

- (void)loadView {
    self.view = [[YLView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:1.0 alpha:1.0];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    _playBtn.frame = CGRectMake(100, 450, 120, 40);
    [_playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    
    _showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_showBtn setTitle:@"show" forState:UIControlStateNormal];
    _showBtn.frame = CGRectMake(100, 400, 120, 40);
    [_showBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showBtn];
    
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_selectBtn setTitle:@"select" forState:UIControlStateNormal];
    _selectBtn.frame = CGRectMake(100, 500, 120, 40);
    [_selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBtn];
    
    CGPoint c = {0,0};
    CGPoint p1 = {1,0};
    CGPoint p2 = {-100000,1};
    CGFloat angle = [self angleForCenterPoint:c andPoint1:p1 andPoint2:p2];
    NSLog(@"angle = %f", angle/M_PI*180.0);
}

- (float)angleForCenterPoint:(CGPoint)center andPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 {
    if (CGPointEqualToPoint(center, p1) || CGPointEqualToPoint(center, p2))
        return 0.0f;
    CGPoint v1 = CGPointMake(p1.x-center.x, p1.y-center.y);
    CGPoint v2 = CGPointMake(p2.x-center.x, p2.y-center.y);
    CGFloat dot = v1.x*v2.x + v1.y*v2.y;
    CGFloat arccos = dot/(sqrt((v1.x*v1.x+v1.y*v1.y)*(v2.x*v2.x+v2.y*v2.y)));
    CGFloat result = acosf(arccos);
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)play:(id)sender {
    [_shareButton animateToDoneWithHandler:nil];
}

- (void)show:(id)sender {
    if (_shareButton)
    {
        [_shareButton removeFromSuperview];
    }
    _shareButton = [[ShareButtonView alloc] initWithIcon:[UIImage imageNamed:@"pinterest"] andTitle:@"Pinterest"];
    _shareButton.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:_shareButton];
    [_shareButton showAnimation];
}

- (void)select:(id)sender {
    static BOOL isSelected = NO;
    if (isSelected) {
        [_shareButton resetAnimation];
    } else {
        [_shareButton selectAnimation];
    }
    
    isSelected = !isSelected;
}

@end
