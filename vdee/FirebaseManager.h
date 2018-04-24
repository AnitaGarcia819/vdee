//
//  FirebaseManager.h
//  vdee
//
//  Created by Brittany Arnold on 4/7/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface FirebaseManager : NSObject {
    
}

+(FirebaseManager*) firebase;
+(FIRRemoteConfig*) remoteConfig;
+ (void)configureRemoteConfig;
+ (void)fetchConfig;

@end
