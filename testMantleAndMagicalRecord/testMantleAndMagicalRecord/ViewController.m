//
//  ViewController.m
//  testMantleAndMagicalRecord
//
//  Created by Yong Li on 8/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "YLDribbbleEngine.h"
#import "YLDribbbleCoreDataManager.h"

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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[YLDribbbleCoreDataManager sharedManager] performBackgroundBlockAndWait:^(NSManagedObjectContext *context) {
                
//                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
//                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postID != nil"];
//                fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"postID" ascending:NO]];
//                NSError* error;
//                NSArray *cachedPosts = [context executeFetchRequest:fetchRequest error:&error];
//                if (!error) {
//                    
//                }
//                else {
//                    NSLog(@"Fetch Error: %@", error);
//                }
                
                YLDribbbleShot* shot = list.shots.firstObject;
                NSError *insertError;
                NSManagedObject *mob = [MTLManagedObjectAdapter managedObjectFromModel:shot
                                                                  insertingIntoContext:context
                                                                                 error:&insertError];
                if (mob) {
                    NSLog(@"Mob: %@", mob);
                } else {
                    NSLog(@"ERROR: %@", insertError);
                }
            }];
        });
    } failedBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
