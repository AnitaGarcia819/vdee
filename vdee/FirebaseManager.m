//
//  FirebaseManager.m
//  vdee
//
//  Created by Brittany Arnold on 4/7/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "FirebaseManager.h"
#import "Constants.h"
@import Firebase;

@implementation FirebaseManager

+(FirebaseManager*) firebase {
    static FirebaseManager *firebase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        firebase = [[FirebaseManager alloc]init];
    });
    return firebase;
}

+(FIRRemoteConfig*) remoteConfig {
    static FIRRemoteConfig *remoteConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        remoteConfig = [FIRRemoteConfig remoteConfig];
    });
    
    return remoteConfig;
}

+ (void)configureRemoteConfig {
    // Enabling developer mode allows many more requests to be made per hour, so developers
    // can test different config values during development.
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
    self.remoteConfig.configSettings = remoteConfigSettings;
}

+ (void)fetchConfig {
    long expirationDuration = 43200; //12 hours in seconds
    // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
    // the server.
    if (self.remoteConfig.configSettings.isDeveloperModeEnabled) {
        expirationDuration = 0;
    }
    // Set default Remote Config parameter values. An app uses the in-app default values until you
    // update any values that you want to change in the Firebase console.
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
    
    // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
    // fetched and cached config would be considered expired because it would have been fetched
    // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
    // throttling is in progress. The default expiration duration is 43200 (12 hours).
    [self.remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"Config fetched!");
            [self.remoteConfig activateFetched];
        } else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
}

@end
