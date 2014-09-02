//
//  MyObject.h
//  testMultithreadingCoreData
//
//  Created by Yong Li on 14-9-2.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyObject : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * name;

@end
