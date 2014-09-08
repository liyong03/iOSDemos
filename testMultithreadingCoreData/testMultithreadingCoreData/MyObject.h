//
//  MyObject.h
//  testMultithreadingCoreData
//
//  Created by Yong Li on 14-9-8.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyObject;

@interface MyObject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) MyObject *subObjs;

@end
