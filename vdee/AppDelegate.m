//
//  AppDelegate.m
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ViewController.h"
#import "Reachability.h"
#import <Fabric/Fabric.h>
@import Firebase;
//#import <Answers/Answers.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
/*
@synthesize reach;

- (void) reachabilityChanged:(NSNotification *)notice
{
    
    NSLog(@"!!!!!!!!!! CODE IS CALL NOW !!!!!!!!!!");
    
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"**** Not Reachable ****");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"**** wifi ****"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"**** cell ****"); }
}
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.reach = [Reachability reachabilityForInternetConnection]; //retain reach
    [reach startNotifier];
    
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    
    NSLog(@"???? ALWAYS INITS WITH Not Reachable ????");
    if(remoteHostStatus == NotReachable) {NSLog(@"init **** Not Reachable ****");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"int **** wifi ****"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"init **** cell ****"); }*/
    
    

    [[UIApplication sharedApplication]
     setMinimumBackgroundFetchInterval:
     UIApplicationBackgroundFetchIntervalMinimum];
    //[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    //[Fabric with:@[[Answers class]]];// Feature tracker.
    
    //Firebase
    [FIRApp configure];
    
    // Override point for customization after application launch.
    // Set AudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    /* Pick any one of them */
    // 1. Overriding the output audio route
    //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    // 2. Changing the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    return YES;
}

-(void)dealloc{
    //[reach release];
    //[super dealloc];
}

-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Background fetch started...");
    //---do background fetch here---
    // You have up to 30 seconds to perform the fetch
    
    ViewController * vc = [[ViewController alloc]init];
    [vc checkInternetConnection];
    
    BOOL downloadSuccessful = YES;
    
    if (downloadSuccessful) {
        //---set the flag that data is successfully downloaded---
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        //---set the flag that download is not successful---
        completionHandler(UIBackgroundFetchResultFailed);
    }
    
    NSLog(@"Background fetch completed...");
}

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    
    // Override point for customization after application launch.
    // Set AudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Pick any one of them
    // 1. Overriding the output audio route
    //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    // 2. Changing the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    return YES;
}*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
