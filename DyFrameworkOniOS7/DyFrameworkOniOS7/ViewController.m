//
//  ViewController.m
//  DyFrameworkOniOS7
//
//  Created by Yong Li on 12/29/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import <HelloKit/HelloKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HelloKit *helloKit = [[HelloKit alloc] init];
    self.label.text = [helloKit getHelloKitName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
