//
//  ViewController.h
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

//UIActivityIndicatorView *indicator;

@interface ViewController : UIViewController <AVPlayerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{

    
}
@property (weak, nonatomic) IBOutlet UICollectionView *radioCollectionView;

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIButton *play_button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *internetOutageMessage0;




- (BOOL) checkInternetConnection;
@end
