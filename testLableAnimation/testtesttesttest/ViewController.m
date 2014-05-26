//
//  ViewController.m
//  testtesttesttest
//
//  Created by Yong Li on 5/26/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import <POPBasicAnimation.h>

@interface ViewController ()

@end

@implementation ViewController

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

- (IBAction)expand:(id)sender {
  
  static BOOL isExpand = NO;
  
  CGRect oldFrame = self.imageView.layer.bounds;
  CGRect newFrame = oldFrame;
  if (isExpand) {
    newFrame.size.height = 50;
  }
  else {
    newFrame.size.height = 100;
  }
  
  CABasicAnimation* expandAnimatino = [CABasicAnimation animationWithKeyPath:@"bounds"];
  expandAnimatino.fromValue = [NSValue valueWithCGRect:oldFrame];
  expandAnimatino.toValue = [NSValue valueWithCGRect:newFrame];
  expandAnimatino.duration = 0.3;
  //expandAnimatino.additive = YES;
  expandAnimatino.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  //self.label.layer.bounds = newFrame;
  [self.imageView.layer addAnimation:expandAnimatino forKey:@"bounds"];
  self.imageView.layer.bounds = newFrame;

  isExpand = !isExpand;
}

- (IBAction)expandText:(id)sender {
  static BOOL isExpand = NO;
  
  CGRect oldFrame = self.label.frame;
  CGRect newFrame = oldFrame;
  if (isExpand) {
    newFrame.size.height = 50;
  }
  else {
    newFrame.size.height = 100;
  }
  
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.label.frame = newFrame;
                     [self.label.superview layoutIfNeeded];
                   }];
  
  isExpand = !isExpand;
}

- (IBAction)expandPop:(id)sender {
  static BOOL isExpand = NO;
  
  CGRect oldFrame = self.label.bounds;
  CGRect newFrame = oldFrame;
  if (isExpand) {
    newFrame.size.height = 50;
  }
  else {
    newFrame.size.height = 100;
  }
  
  POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
  animation.toValue = [NSValue valueWithCGRect:newFrame];
  [self.label.layer pop_addAnimation:animation forKey:@"expand"];
  
  
  isExpand = !isExpand;
}
@end
