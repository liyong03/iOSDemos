//
//  AppDelegate.m
//  testRedditAPI
//
//  Created by Yong Li on 8/5/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "AppDelegate.h"
#import <NXOAuth2.h>

@implementation AppDelegate

+ (void)initialize;
{
    [[NXOAuth2AccountStore sharedStore] setClientID:@"lyaFw-a3NhN-fA"
                                             secret:@"VU6J1859ZMaFd4yLshkFmQycMcI"
                                   authorizationURL:[NSURL URLWithString:@"https://ssl.reddit.com/api/v1/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://ssl.reddit.com/api/v1/access_token"]
                                        redirectURL:[NSURL URLWithString:@"redditbot://ios"]
                                     forAccountType:@"redditBot"];
    NSDictionary* config = [[NXOAuth2AccountStore sharedStore] configurationForAccountType:@"redditBot"];
    NSMutableDictionary* newConfig = [NSMutableDictionary dictionaryWithDictionary:config];
    [newConfig setObject:[NSSet setWithObjects:@"account", nil] forKey:kNXOAuth2AccountStoreConfigurationScope];
    [[NXOAuth2AccountStore sharedStore] setConfiguration:newConfig forAccountType:@"redditBot"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

@end
