//
//  ViewController.m
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h> // If using Answers with Crashlytics
//#import <Answers/Answers.h> // If using Answers without Crashlytics


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *play;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *internetMessage;

@end

@implementation ViewController
@synthesize player;
@synthesize playerItem;
@synthesize play_button;
@synthesize internetOutageMessage0;

BOOL isPlaying = false;
BOOL isLoading = false;
BOOL noInternet = false;
BOOL wasInterupted = false;
//Reachability *reach;

- (BOOL)canBecomeFirstResponder { return YES;}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Check Internet connection
    // Allocate a reachability object (Checks internet connection)
    [self setupInternetConnection];
    
    // Internet error message
    internetOutageMessage0.hidden = TRUE;
    
    // Connect loading view with scroll view
    //self.scrollView.pagingEnabled = YES;
   
    // Loading view
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(145, 145, 145, 145)];
    self.loadingView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/3);
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    
    // Loading spinner
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.frame = CGRectMake(50,
                                                  50,
                                                  self.activityIndicatorView.bounds.size.width,
                                                  self.activityIndicatorView.bounds.size.height);
    [self.loadingView addSubview:self.activityIndicatorView];
    
    //TEMP
    /*
    play_button.hidden = TRUE;
    [self.activityIndicatorView startAnimating];
    [self.loadingView addSubview:self.loadingLabel];
    [self.scrollView addSubview:self.loadingView];
    self.loadingLabel.text = @"LOADING";
    */
    
    //Loading label
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (IBAction)play_button:(id)sender {
    // Removes InternetError Message
    internetOutageMessage0.hidden = TRUE;
    
    if (!isPlaying) {
        
        [play_button setTitle:@"Trigger Key Metric" forState:UIControlStateNormal];
        [play_button addTarget:self action:@selector(anImportantUserAction) forControlEvents:UIControlEventTouchUpInside];
        [self playRadio];
        
        
        
    }else{
        [self stopRadio];
    }
}

- (void) stopRadio{
    // Stops radio
    player.rate = 0.0;
    // Display play image from the stop image that is shown while playing
    [self changeButtonImg:@"play.png"];
    isPlaying = false;
}
- (void) playRadio {
    // Check for conectivity
    if(!([self setupInternetConnection])){
        NSLog(@"(playRadio) Not ready to play");
        // Let user know no internet connection is established
        [self displayInternetErrorMessage];
        // Stop loading img
        //TODO: Add timer to this
        if(isLoading){
            [self stopLoadingBox];
        }
        // Change image back to play img
        [self changeButtonImg:@"play.png"];
        // Check internet connection
        [self setupInternetConnection];
        // TODO: Make a call to check connectivity
    }
    else{
        NSLog(@"(playRadio) WAS REACHABLE");
        //[self removeInternetErrorMessage];
        [self activateRadio];
    
    }// End if else
}

- (void) changeButtonImg:( NSString *) message {
    UIImage *img = [UIImage imageNamed:message];
    [play_button setImage:img forState:UIControlStateNormal];
    play_button.hidden = FALSE;
}

- (void)displayInternetErrorMessage {
    internetOutageMessage0.hidden = FALSE;
}

- (void)removeInternetErrorMessage {
    internetOutageMessage0.hidden = TRUE;
}

- (void)stopLoadingBox {
    isLoading = FALSE;
    [self.activityIndicatorView stopAnimating];
    [self.loadingView removeFromSuperview];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayLoadingScreen:( NSString *) message {
    isLoading = TRUE;
    play_button.hidden = TRUE;
    [self.activityIndicatorView startAnimating];
    [self.loadingView addSubview:self.loadingLabel];
    [self.scrollView addSubview:self.loadingView];
    self.loadingLabel.text = message;
}

- (void) activateRadio {
     [self displayLoadingScreen:@"Cargando. . . "];
    // Play radio
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vdee.org:8000/salinas"]]];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    [player play];
    
    // Background thread checks if player is ready to play
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Waits until AVPlayer is ready to play
        while (self.player.currentItem.status !=  AVPlayerItemStatusReadyToPlay){
            //NSLog(@"Loading");
        }
        NSLog(@"(playRadio) Ready to play");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // stop the activity indicator (you are now on the main queue again)
           if (player.status ==  AVPlayerItemStatusReadyToPlay){
                // Hide loading box
                [self stopLoadingBox];
                
                // Show stop image
                [self changeButtonImg:@"stop.png"];
                
                // Change play flag
                isPlaying = true;
               
            }
        });
    });
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
            if(isLoading){
                [self stopLoadingBox];
                [self activateRadio];
                //play_button.hidden = FALSE;
                //player.rate = 0.0;
            }
            
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
            // Show correct image
            if(isPlaying){
                //[self changeButtonImg:@"play.png"];
                [self displayLoadingScreen:@"Cargando. . . "];
                isPlaying = FALSE;
                isLoading = TRUE;
            }
            NSLog(@"UNREACHABLE.");
        });
    };
    return reach.isReachable;
}
- (void)anImportantUserAction {
    // TODO: Move this method and customize the name and parameters to track your key metrics
    //       Use your own string attributes to track common values over time
    //       Use your own number attributes to track median value over time
    [Answers logCustomEventWithName:@"Music button was hit!!" customAttributes:@{@"Category":@"Comedy", @"Length":@350}];
}


- (BOOL) checkInternetConnection {
   // return reach.isReachable;
    return true;
}


- (void)routeChange:(NSNotification*)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            // a headset was removed
            NSLog(@"routeChangeReason : AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            if(isLoading){
                [self stopLoadingBox];
            }
            [self stopRadio];
            break;
        default:
            break;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end





