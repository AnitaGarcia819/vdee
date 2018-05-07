//
//  RadioWithPullUpViewVC.h
//  vdee
//
//  Created by Nicholas Rosas on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FirebaseManager.h"
@import Firebase;
@import ISHPullUp;

@interface RadioWithPullUpViewVC : UIViewController <ISHPullUpContentDelegate, AVPlayerViewControllerDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIButton *play_button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *internetOutageMessage0;

- (BOOL) checkInternetConnection;

@end
