//
//  ViewController.m
//  testRedditAPI
//
//  Created by Yong Li on 8/5/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import <NXOAuth2.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      // Update your UI
                                                      NSLog(@"success: %@", aNotification);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      // Do something with the error
                                                      NSLog(@"error: %@", error);
                                                  }];
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"redditBot"];
//                                                              username:@"liyong03"
//                                                              password:@"388135_yjz"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
