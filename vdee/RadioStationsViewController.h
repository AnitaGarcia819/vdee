//
//  RadioStationsViewController.h
//  vdee
//
//  Created by Jesus perez on 4/18/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface RadioStationsViewController : UIViewController <AVPlayerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate >{
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *radioCollectionView;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIButton *play_button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *internetOutageMessage0;

- (BOOL) checkInternetConnection;
@end

