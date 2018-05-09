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
#import "RadioStationsViewController.h"
#import "Reachability.h"
#import <Fabric/Fabric.h>
#import "Constants.h"
#import "FirebaseManager.h"

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

UITabBarController* tabBarController;

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
    
    //Firebase
    [FIRApp configure];
    
    //Sets up Firebase
    [FirebaseManager configureRemoteConfig];
    [FirebaseManager firebase];
    [FirebaseManager fetchConfig];
    
    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];

    BOOL tabViewEnabled = remoteConfig[tabViewEnabledConfigKey].boolValue;
    BOOL shareBtnEnabled = remoteConfig[shareBtnEnabledConfigKey].boolValue;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (tabViewEnabled) {
        // setup window
        // ** TabBarController setup
        tabBarController = [[UITabBarController alloc] init];
        
        // setup viewController to add to TabController
        // instantiate view from storyboard
        // create NavigationController to embed to ViewController (optional)
            /*
                Note: if you don't embed a Navigation Controller;
                then, you have to set the tab bar title in the ViewWillAppear method
                in the desired ViewController
              */
        
        // Example of adding a tab to a view controller and embeding a navigation controller
        // Note: when using following example, replace identifiers with your own
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RadioVC"];
        //UINavigationController *navRadio = [[UINavigationController alloc] initWithRootViewController:vc];
        // set tab bar title since using a navigation controller, otherwise set in ViewWillAppear of ViewController
        //[navRadio.tabBarItem setTitle:@"Radio Player"];
        
        UIViewController *fbFeedVC = [storyboard instantiateViewControllerWithIdentifier:@"FBFeedVC"];
        UINavigationController *navFBFeed = [[UINavigationController alloc] initWithRootViewController:fbFeedVC];
        [navFBFeed.tabBarItem setTitle:@"FB Group"];

        UIViewController *mrvc = [storyboard instantiateViewControllerWithIdentifier:@"MultipleRadioVC"];
        UINavigationController *mnavRadio = [[UINavigationController alloc] initWithRootViewController:mrvc];
        [mnavRadio.tabBarItem setTitle:@"Radio Stations"];
      
        UIViewController *bibvc = [storyboard instantiateViewControllerWithIdentifier:@"BibleVC"];
        UINavigationController *navBible = [[UINavigationController alloc] initWithRootViewController:bibvc];
        [navBible.tabBarItem setTitle:@"Bible"];
        
        //add ViewControllers or NavigationControllers to array (required **)
        NSArray* controllers = [NSArray arrayWithObjects: mnavRadio, navFBFeed, navBible, nil];
        tabBarController.viewControllers = controllers;
        self.window.rootViewController = tabBarController;
    } else {
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RadioVC"];
        
        // check if share btn enabled,to either add navigation controller to use nav bar for share btn
        if (shareBtnEnabled) {
            UINavigationController *navRadio = [[UINavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = navRadio;
        } else {
            self.window.rootViewController = vc;
        }
    }
    [self.window makeKeyAndVisible];
    

    [[UIApplication sharedApplication]
     setMinimumBackgroundFetchInterval:
     UIApplicationBackgroundFetchIntervalMinimum];
[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    //[Fabric with:@[[Answers class]]];// Feature tracker.
    
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
    //[tabBarController release];
}

-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Background fetch started...");
    //---do background fetch here---
    // You have up to 30 seconds to perform the fetch
    
    RadioStationsViewController * vc = [[RadioStationsViewController alloc]init];
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
