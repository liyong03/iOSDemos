//
//  YLViewController.m
//  testMultithreadingCoreData
//
//  Created by Yong Li on 14-9-2.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import "YLViewController.h"
#import "YLAppDelegate.h"
#import "Store.h"
#import "MyObject.h"
#import <CoreData/CoreData.h>
#import <ReactiveCocoa.h>

@interface YLViewController ()

@end

@implementation YLViewController {
    MyObject *_mainObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      NSLog(@"notify = %@", note);
                                                  }];
    
    NSManagedObjectContext* context = [YLAppDelegate appDelegate].store.mainManagedObjectContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyObject"];
    fetchRequest.fetchLimit = 1;
    _mainObject = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    
    RAC(self.numberLabel, text) = [RACObserve(_mainObject.subObjs, value) map:^id(id value) {
        return [NSString stringWithFormat:@"%@", value];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createOrLoad:(id)sender {
    NSManagedObjectContext* context = [YLAppDelegate appDelegate].store.mainManagedObjectContext;
    
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyObject"];
    fetchRequest.fetchLimit = 1;
    _mainObject = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if(_mainObject == nil) {
        _mainObject = [MyObject MR_createInContext:context];//[NSEntityDescription insertNewObjectForEntityForName:@"MyObject" inManagedObjectContext:context];
        
        MyObject *subObj = [MyObject MR_createInContext:context];//[NSEntityDescription insertNewObjectForEntityForName:@"MyObject" inManagedObjectContext:context];
        subObj.name = @"sub";
        subObj.value = @(200);
        _mainObject.subObjs = subObj;
        
        RAC(self.numberLabel, text) = [RACObserve(_mainObject.subObjs, value) map:^id(id value) {
            return [NSString stringWithFormat:@"%@", value];
        }];
    }
    
    
    _mainObject.name = @"main";
    _mainObject.value = @(100);
    _mainObject.subObjs.value = @(200);
    
    [[YLAppDelegate appDelegate].store saveContext];
}


- (IBAction)loadAndChangeInBackgroundThread:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSManagedObjectContext* bgContext = [[YLAppDelegate appDelegate].store newPrivateContext];
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyObject"];
        fetchRequest.fetchLimit = 1;
        MyObject* bgObject = [[bgContext executeFetchRequest:fetchRequest error:NULL] lastObject];
        NSLog(@"bgObject = %@", bgObject);
        NSLog(@"name = %@", bgObject.name);
        NSLog(@"val = %@", bgObject.value);
        
        bgObject.subObjs.value = @(20);
        [bgContext save:NULL];
    });
}

@end
