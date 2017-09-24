//
//  AppDelegate.h
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic)  Reachability* reach;

@end

