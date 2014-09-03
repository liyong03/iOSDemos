//
//  YLAppDelegate.h
//  testMultithreadingCoreData
//
//  Created by Yong Li on 14-9-2.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Store;
@interface YLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) Store* store;

+ (YLAppDelegate*)appDelegate;

@end
