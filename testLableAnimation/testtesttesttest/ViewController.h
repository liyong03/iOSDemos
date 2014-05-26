//
//  ViewController.h
//  testtesttesttest
//
//  Created by Yong Li on 5/26/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *Expand;
- (IBAction)expand:(id)sender;
- (IBAction)expandText:(id)sender;
- (IBAction)expandPop:(id)sender;

@end
