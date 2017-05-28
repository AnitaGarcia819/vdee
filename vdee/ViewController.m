//
//  ViewController.m
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

@interface ViewController ()
{
    Reachability *reach;
}
@end

@interface ViewController ()

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

BOOL isPaused = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testInternetConnection];
    
    // Loading view
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    self.loadingView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    
    // Loading spinner
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.frame = CGRectMake(65, 40, self.activityIndicatorView.bounds.size.width, self.activityIndicatorView.bounds.size.height);
    [self.loadingView addSubview:self.activityIndicatorView];
    
    //Loading label
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
}

-(void) testInternetConnection{
    // Allocate a reachability object (Checks internet connection)
   reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            internetOutageMessage0.hidden = TRUE;
            NSLog(@"REACHABLE!");
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //self.loadingLabel.text = @"Compruebe";
        //[self.activityIndicatorView stopAnimating];
        //[self.loadingView removeFromSuperview];
        //[self message_box:@"Compruebe su conexión a Internet y vuelva a intentarlo."];
        dispatch_async(dispatch_get_main_queue(), ^{
            internetOutageMessage0.hidden = FALSE;
            NSLog(@"Compruebe su conexión a Internet y vuelva a intentarlo.");
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (IBAction)play_button:(id)sender {
    
        if (isPaused) {
            
            playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vdee.org:8000/salinas"]]];
            player = [AVPlayer playerWithPlayerItem:playerItem];
            [player play];
            //[self.player.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
            
            // Loading box is shown
            [self message_box:@"Loading. . . "];
            [self.activityIndicatorView startAnimating];
            
            // Background thread checks if player is ready to play
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              
               while (self.player.currentItem.status !=  AVPlayerItemStatusReadyToPlay){
             
                   //NSLog(@"Loading");

                }
                //NSLog(@"Ready");

               
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // stop the activity indicator (you are now on the main queue again)
                    if (player.status ==  AVPlayerItemStatusReadyToPlay){
                        [self.activityIndicatorView stopAnimating];
                        [self.loadingView removeFromSuperview];
                        UIImage *stopImg = [UIImage imageNamed:@"stop.png"];
                        [play_button setImage:stopImg forState:UIControlStateNormal];
                        isPaused = false;
                    }
                });
            });
    
        }else{
            player.rate = 0.0;
            UIImage *playImg = [UIImage imageNamed:@"play.png"];
            [play_button setImage:playImg forState:UIControlStateNormal];
            isPaused = true;
            //player = nil;
        }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if(self.player.currentItem.status == AVPlayerItemStatusReadyToPlay){
        //do something
        
        NSLog(@"player item status is ready to play");
        [self.activityIndicatorView stopAnimating];
        [self.loadingView removeFromSuperview];
        UIImage *stopImg = [UIImage imageNamed:@"stop.png"];
        [play_button setImage:stopImg forState:UIControlStateNormal];
        isPaused = false;
    }
}

- (void) message_box:( NSString *) message
{
    [self.loadingView addSubview:self.loadingLabel];
    [self.view addSubview:self.loadingView];
    self.loadingLabel.text = message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
