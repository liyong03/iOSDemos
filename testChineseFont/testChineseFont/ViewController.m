//
//  ViewController.m
//  testChineseFont
//
//  Created by Yong Li on 7/4/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "FontTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIFont* font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:30];
    self.textView.font = font;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeFont:(id)sender {
    [FontTableViewController showFontSelectionViewController:^(NSString *fontName) {
        self.textView.font = [UIFont fontWithName:fontName size:30];
    }];
}
@end
