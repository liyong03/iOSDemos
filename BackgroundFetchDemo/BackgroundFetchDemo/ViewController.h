//
//  ViewController.h
//  BackgroundFetchDemo
//
//  Created by Gabriel Theodoropoulos on 22/2/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblNews;


-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (IBAction)removeDataFile:(id)sender;

@end
