//
//  HelloKit.m
//  DyFrameworkOniOS7
//
//  Created by Yong Li on 12/29/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "HelloKit.h"

@implementation HelloKit

- (NSString*)getHelloKitName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSLog(@"doc = %@", documentsPath);
    
    return @"Hello from dynamic framework";
}

@end
