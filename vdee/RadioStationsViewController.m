//
//  RadioStationsViewController.m
//  vdee
//
//  Created by Jesus perez on 4/18/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

@import MediaPlayer;
#import <UIKit/UIKit.h>
#import "radioCollectionViewCell.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <Crashlytics/Crashlytics.h> // If using Answers with Crashlytics
//#import <Answers/Answers.h> // If using Answers without Crashlytics
#import "FirebaseManager.h"
@import Firebase;
#import "RadioStationsViewController.h"

@interface RadioStationsViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *play;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *internetMessage;
@end
@implementation RadioStationsViewController
@synthesize player;
@synthesize playerItem;
@synthesize play_button;
@synthesize internetOutageMessage0;
// Checks for which cell within the collection view is being used
NSInteger buttonindexpath;
BOOL isPlayingCell0 = false;
BOOL isPlayingCell1 = false;
BOOL isPlayingCell2 = false;
BOOL isPlayingCell3 = false;
// Checks for which radio station is playing
BOOL isPlaying1 = false;
BOOL noInternet1 = false;
BOOL wasInterupted1 = false;
MPRemoteCommandCenter *rcc1;
MPRemoteCommand *playCommand1 ;
MPRemoteCommand *pauseCommand1;
MPRemoteCommand *nextTrackCommand;
MPNowPlayingInfoCenter* info;
// A re-usable cell given an identifier.
static NSString * const reuseIdentifier = @"Cell1";
NSInteger lastPlayedIndex = -1;
static NSInteger const RADIO_COUNT = 4;
static NSString * const RADIO_TITLE[] = {
    [0] = @"Salinas",
    [1] = @"King City",
    [2] = @"Zion",
    [3] = @"Internacional",
    // ...
};

static NSString * const RADIO_URLS[] = {
    [0] = @"http://www.vdee.org:8000/salinas",
    [1] = @"http://107.215.165.202:8000/resplandecer",
    [2] = @"http://unoredradio.com:9736/",
    [3] = @"http://162.219.28.116:9638/;",
    // ...
};
BOOL isWaitingForPlayer = false;

- (BOOL)canBecomeFirstResponder { return YES;}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //The setup code (in viewDidLoad in your view controller)
    
    // Check Internet connection
    // Allocate a reachability object (Checks internet connection)
    [self setupInternetConnection];
    
    // Internet error message
    internetOutageMessage0.hidden = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    rcc1 = [MPRemoteCommandCenter sharedCommandCenter];
    playCommand1 = rcc1.playCommand;
    pauseCommand1 = rcc1.pauseCommand;
    nextTrackCommand = rcc1.nextTrackCommand;
    playCommand1.enabled = YES;
    pauseCommand1.enabled = YES;
    nextTrackCommand.enabled = YES;
    
    
}


// Stops radio
- (void) stopRadio {
    player.rate = 0.0;
   // Stops the radio station that is playing, also resets all cells.
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastPlayedIndex inSection:0];
    radioCollectionViewCell * cell = (radioCollectionViewCell *) [_radioCollectionView cellForItemAtIndexPath:indexPath];
    [self changeButtonImg:cell.playButton name:@"play1.png"];
    isPlaying1 = false;
    isPlayingCell0 = false;
    isPlayingCell1 = false;
    isPlayingCell2 = false;
    isPlayingCell3 = false;
    
}
- (void)displayInternetErrorMessage {
    internetOutageMessage0.hidden = FALSE;
}

- (void)removeInternetErrorMessage {
    internetOutageMessage0.hidden = TRUE;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) setupInternetConnection {
    // Loading screen and hide play button while loading
    NSLog(@"CHECKING INTERNET CONNECTION");
    // Allocate a reachability object (Checks internet connection)
    Reachability *reach = [Reachability reachabilityWithHostname:@"http://www.google.com"];
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach) {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        NSLog(@"Reachable Block: ON");
        //[self activateRadio];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            // Check if phone is recovering from an interuption
            [self removeInternetErrorMessage];
            NSLog(@"REACHABLE!");
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach) {
        //self.loadingLabel.text = @"Compruebe";
        //[self.activityIndicatorView stopAnimating];
        //[self.loadingView removeFromSuperview];
        //[self message_box:@"Compruebe su conexión a Internet y vuelva a intentarlo."];
        NSLog(@"Reachable Block: OFF");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Checks for internet interuption
            /*if(isLoading){
             NSLog(@"Reachability: INTERUPTION");
             [self stopLoadingBox];
             }*/
           
            if(isPlaying1){
                isPlaying1 = FALSE;
            }
            NSLog(@"UNREACHABLE.");
            
        });
    };
    return reach.isReachable;
}

- (BOOL) checkInternetConnection {
    // return reach.isReachable;
    return true;
}
// hANDLING THE UICOLLECTION VIEW
- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection:(NSInteger)section {
    // Returns the number of cells that are being used.
    return RADIO_COUNT;
}

- (void) collectionView: (UICollectionView *) collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    radioCollectionViewCell * radioCell = (radioCollectionViewCell *) cell;
//    switch (
//    if (!isPlayingCell3 && radioCell.playButton.tag == 3) {
//        UIImage *btnImage = [UIImage imageNamed:@"play.png"];
//        [radioCell.playButton setImage:btnImage forState:UIControlStateNormal];
//    }
//    if (isPlayingCell1 && radioCell.playButton.tag == 1) {
//        UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//        [radioCell.playButton setImage:btnImage forState:UIControlStateNormal];
//    }
}
- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
     [collectionView flashScrollIndicators];
    radioCollectionViewCell *cell = (radioCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (isWaitingForPlayer && ![cell.act isAnimating] && indexPath.row == lastPlayedIndex) {
        [cell.act startAnimating];
    }
    cell.label.text = RADIO_TITLE[indexPath.row];
    cell.playButton.tag = indexPath.row;
    if (isPlaying1 && indexPath.row == lastPlayedIndex) {
        [self changeButtonImg:cell.playButton name:@"stop.png"];
    } else if(isWaitingForPlayer && indexPath.row == lastPlayedIndex) {
        [cell.loadingMessage setHidden:false];
        [cell.loadingLabel setHidden:false];
        [cell.playButton setHidden:true];
    } else {
        [cell.loadingMessage setHidden:true];
        [cell.loadingLabel setHidden:true];
        [cell.playButton setHidden:false];
        [self changeButtonImg:cell.playButton name:@"play1.png"];
    }
    return cell;
}

-(void) playRadioCell:(NSString*) radioLink: (id) sender {
    // Check for conectivity
    if(!([self setupInternetConnection])){
        NSLog(@"(playRadio) Not ready to play");
        // Let user know no internet connection is established
        [self displayInternetErrorMessage];
        // Stop loading img
        //TODO: Add timer to this
        // Change image back to play img
        // [self changeButtonImg:@"play.png"];
        // Check internet connection
        [self setupInternetConnection];
        // TODO: Make a call to check connectivity
    } else {
        NSLog(@"(playRadio) WAS REACHABLE");
        //[self removeInternetErrorMessage];
        [self activateRadioCell: radioLink: sender];
    }// End if else
}

- (void) activateRadioCell:(NSString*) link: (id) sender {
    // With the sender object we are able to identify which button within a cell is being played.
    UIButton *button = (UIButton *)sender;
    //Once we have the button we can check it's super view to understand what cell needs to be manipulated. Also the cell contains a loading indicator view, grabbing it's superview is great to manipulate objects within the cell.
    radioCollectionViewCell *cell = (radioCollectionViewCell *)[[button superview] superview];
    [cell.act startAnimating];
     cell.loadingLabel.layer.cornerRadius = 10.0;
    [cell.loadingMessage setHidden:false];
    [cell.playButton setHidden:true];
    [cell.loadingLabel setHidden:false];
    // Play radio
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", link]]];
    NSLog(@"%@", playerItem);
    player = [AVPlayer playerWithPlayerItem:playerItem];

    
    [player play];

    
    // Background thread checks if player is ready to play
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Waits until AVPlayer is ready to play
        isWaitingForPlayer = true;
        while (self.player.currentItem.status !=  AVPlayerItemStatusReadyToPlay){
            //NSLog(@"Loading");
        }
        NSLog(@"(playRadio) Ready to play");
        dispatch_sync(dispatch_get_main_queue(), ^{
            // stop the activity indicator (you are now on the main queue again)
            if (player.status ==  AVPlayerItemStatusReadyToPlay){
                // Hide loading box
                isWaitingForPlayer = false;
                [cell.act stopAnimating];
                [self changeButtonImg:cell.playButton name:@"stop.png"];
               // UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
               // [cell.playButton setImage:btnImage forState:UIControlStateNormal];
                // Change play flag
               cell.loadingLabel.layer.cornerRadius = 10.0;
                [cell.loadingMessage setHidden:true];
                [cell.loadingLabel setHidden:true];
                [cell.playButton setHidden:false];
                isPlaying1 = true;
                switch ([sender tag]) {
                        case 0:
                isPlayingCell0 = true;
                        break;
                        case 1:
                isPlayingCell1 = true;
                        break;
                        case 2:
                isPlayingCell2 = true;
                        break;
                        case 3:
                isPlayingCell3 = true;
                        break;
                        default:
                        break;
                }
            }
        });
    });
}

// These methods are used to provide a better flow when the user interacts with the uicollection view.
// Center cells in the middle
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * cellWidth) - ((cellCount - 1)*cellSpacing)) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

// Snap to position
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    float pageWidth = 373 +250; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset) {
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    } else {
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    }
    if (newTargetOffset < 0) {
        newTargetOffset = 0;
    } else if (newTargetOffset > scrollView.contentSize.width) {
        newTargetOffset = scrollView.contentSize.width;
    }
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
}

// When the user clicks the button this action gets triggered.
// Converting sender object into a button to be able to edit the buttons image
// The sender is also passed in playRadioCell method to determine where the button was pressed and what activity indicator to display.
- (IBAction)buttonClicked:(id)sender {
    NSMutableDictionary* newInfo = [NSMutableDictionary dictionary];
    info = [MPNowPlayingInfoCenter defaultCenter];
    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];
    UIButton *button = (UIButton *)sender;

    if (isPlaying1) {
        [self stopRadio];
      
    } else {
        if (remoteConfig[controlCenterEnabled].boolValue){
            //firebase wrapper for background controller
            [playCommand1 addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
                [player play];
                [self changeButtonImg:button name:@"stop.png"];
                return MPRemoteCommandHandlerStatusSuccess;
                //command handler  gets access to playRadio function, in background, lockscreen and control center
            }];
        }
        
        lastPlayedIndex = [sender tag];
        
        [self changeButtonImg:button name:@"stop.png"];
        //[Answers logCustomEventWithName:@"Salinas Was Played" customAttributes:@{@"Category":@"Radio Stations", @"Length":@350}];
        [self playRadioCell: RADIO_URLS[lastPlayedIndex]: sender];
        [newInfo setObject:RADIO_TITLE[lastPlayedIndex] forKey:MPMediaItemPropertyTitle];
        //[newInfo setObject:RADIO_URLS[lastPlayedIndex] forKey:MPMediaItemPropertyArtist];
        //adds link to source, but it can be ignored.

        info.nowPlayingInfo = newInfo;

        if (remoteConfig[controlCenterEnabled].boolValue){
            //firebase wrapper for background controller
            [pauseCommand1 addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
                [self stopRadio];
                [self changeButtonImg:button name:@"play.png"];
                return MPRemoteCommandHandlerStatusSuccess;
                //command handler  gets access to stopRadio function, in background, lockscreen and control center
            }];
        }
        [self changeRadioStation:sender] ;
        
  
    }
}
- (void)changeRadioStation:(id)sender {
    NSMutableDictionary* newInfo = [NSMutableDictionary dictionary];
    lastPlayedIndex = [sender tag];
    [nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        lastPlayedIndex++;
        if(lastPlayedIndex > 3){
            lastPlayedIndex = 0;
        }
        [self playRadioCell: RADIO_URLS[lastPlayedIndex]: sender];
        [newInfo setObject:RADIO_TITLE[lastPlayedIndex] forKey:MPMediaItemPropertyTitle];
        //[newInfo setObject:RADIO_URLS[lastPlayedIndex] forKey:MPMediaItemPropertyArtist];
        //adds link to source, but it can be ignored.
        
        info.nowPlayingInfo = newInfo;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastPlayedIndex inSection:lastPlayedIndex];
        radioCollectionViewCell * cell = (radioCollectionViewCell *) [_radioCollectionView cellForItemAtIndexPath:indexPath];
        cell.playButton.tag = indexPath.row;
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];

        return MPRemoteCommandHandlerStatusSuccess;
    }];
    

}

- (void)routeChange:(NSNotification*)notification {
    NSDictionary *interruptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interruptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            // a headset was removed
            NSLog(@"routeChangeReason : AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            [self stopRadio];
            break;
        default:
            break;
    }
}

- (void) changeButtonImg: (UIButton *) btn name: (NSString *) imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    [btn setImage:img forState:UIControlStateNormal];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end




