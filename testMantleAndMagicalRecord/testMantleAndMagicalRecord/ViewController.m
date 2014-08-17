//
//  ViewController.m
//  testMantleAndMagicalRecord
//
//  Created by Yong Li on 8/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "YLDribbbleEngine.h"

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

- (IBAction)downloadPopular:(id)sender {
    [YLDribbbleEngine getPopularShotsWithPage:1 successBlock:^(YLDribbbleShotList *list) {
        NSLog(@"list: %@", list);
    } failedBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
