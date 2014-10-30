//
//  AppDelegate.m
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@implementation AppDelegate
Reachability *reach;
-(NSString *) stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    switch (status)
    {
        case NotReachable:
            string = @"No Connection";
            _hasInternet = NO;
            break;
        case ReachableViaWiFi:
            string = @"WiFi Connected";
            _hasInternet = YES;
            break;
        case ReachableViaWWAN:
            string = @"Connected";
            _hasInternet = YES;
            break;
        default:
            break;
    }
    return string;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus status = [reach currentReachabilityStatus];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Status" message:[self stringFromStatus:status] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self reachabilityChanged:status];
    return YES;
}

- (void) reachabilityChanged:(NetworkStatus) status
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterfaceWithReachability:) name:kReachabilityChangedNotification object:nil];
    switch (status)
    {
        case NotReachable: _hasInternet = NO;
            break;
        case ReachableViaWiFi :_hasInternet = YES;
            break;
        case ReachableViaWWAN : _hasInternet = YES;
            break;
        default:
            break;
    }
}

- (void)updateInterfaceWithReachability:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Status" message:[self stringFromStatus:remoteHostStatus] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

@end
