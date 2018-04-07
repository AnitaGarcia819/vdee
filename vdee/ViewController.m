//
//  ViewController.m
//  vdee
//
//  Created by Anita Garcia on 5/8/17.
//  Copyright © 2017 Anita Garcia. All rights reserved.
//
#import "radioCollectionViewCell.h"
#import "ViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h> // If using Answers with Crashlytics
//#import <Answers/Answers.h> // If using Answers without Crashlytics


@interface ViewController ()
{
    NSArray *buttons;
}



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

//**********


BOOL isPlayingCell0 = false;
BOOL isPlayingCell1 = false;
//**********

BOOL isPlaying = false;
BOOL isLoading = false;
BOOL noInternet = false;
BOOL wasInterupted = false;
//Reachability *reach;

static NSString * const reuseIdentifier = @"Cell1";

- (BOOL)canBecomeFirstResponder { return YES;}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // buttons = [NSArray arrayWithObjects:@"play.png",nil];
//     [self.radioCollectionView registerClass:[radioCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
   
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
}
// Method for big play button
- (IBAction)play_button:(id)sender {
    // Removes InternetError Message
    internetOutageMessage0.hidden = TRUE;
    
    if (!isPlaying) {
        
      //  [play_button setTitle:@"Trigger Key Metric" forState:UIControlStateNormal];
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
   // [self changeButtonImg:@"play.png"];
    isPlaying = false;
    isPlayingCell0 = false;
    isPlayingCell1 = false;
    
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
      //  [self changeButtonImg:@"play.png"];
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
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.215.165.202:8000/resplandecer"]]];
  //"http://www.vdee.org:8000/salinas"
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
                isPlayingCell0 = true;
                isPlayingCell1 = true;
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
    [Answers logCustomEventWithName:@"Music button was hit!!" customAttributes:@{@"Category":@"Vdee-analytics", @"Length":@350}];
}


- (BOOL) checkInternetConnection {
   // return reach.isReachable;
    return true;
}
// hANDLING THE UICOLLECTION VIEW
- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection:(NSInteger)section {
    
    printf("callll");
    
    return 2;
    
}



- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //UICollectionViewCell *cell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    static NSString *identifier = @"Cell1";
    //printf("Index Path:", indexPath);
    
   
    radioCollectionViewCell *cell = (radioCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     UIImage *btnImage = [UIImage imageNamed:@"play.png"];
    //        [btnTwo setImage:btnImage forState:UIControlStateNormal]
     [cell.playButton setImage:btnImage forState:UIControlStateNormal];
    
    
    return cell;
    
}



- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
//    printf("%ld", (long)indexPath.row);
//
//    printf("%ld", (long)indexPath.section);
//
//
//
//    UICollectionViewCell * cell = (UICollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    // printf("Item at: %ld", (long)indexPath.item);
    radioCollectionViewCell *datasetCell =(radioCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor]; // highlight selection
   // NSIndexPath* ix = [self.radioCollectionView indexPathForCell: datasetCell];
    // printf("%ld", (long)ix);
    NSLog(@"%@", indexPath);
    NSLog(@"Row: %ld", (long)indexPath.row);
    NSLog(@"Section: %ld", (long)indexPath.section);
    if(indexPath.row == 0)
    {
        
        printf("Hello 0");
         //[self playRadio];
       // UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
        //        [btnTwo setImage:btnImage forState:UIControlStateNormal]
      //  [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
        
       // datasetCell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"stop.png"]];
        
        if (!isPlayingCell0) {
            
            //  [play_button setTitle:@"Trigger Key Metric" forState:UIControlStateNormal];
            //Fabric metrics
           // [play_button addTarget:self action:@selector(anImportantUserAction) forControlEvents:UIControlEventTouchUpInside];
            //[self playRadio];
             UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
            [self playRadioCell:@"http://www.vdee.org:8000/salinas"];
            
            
            
        }else{
            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
            [self stopRadio];
        }
        
        
    }
    else if(indexPath.row == 1)
    {
         printf("Hello 1");
        //datasetCell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"stop.png"]];
        //UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//        [btnTwo setImage:btnImage forState:UIControlStateNormal]
        //[datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
        
        if (!isPlayingCell1) {
            
            //  [play_button setTitle:@"Trigger Key Metric" forState:UIControlStateNormal];
            //Fabric metrics
           // [play_button addTarget:self action:@selector(anImportantUserAction) forControlEvents:UIControlEventTouchUpInside];
            //[self playRadio];
            UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
            [self playRadioCell:@"http://107.215.165.202:8000/resplandecer"];
            
            
            
        }else{
            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
            [self stopRadio];
        }
        
        
    }
    else if(indexPath.row == 2)
    {
         printf("Hello 2");
         //datasetCell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"stop.png"]];
        
    }
    else{
         printf("Error 404");
        
        
    }
    
    return datasetCell;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath  {

    radioCollectionViewCell *datasetCell =(radioCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor redColor]; // Default color
    return datasetCell;
}

-(void) playRadioCell:(NSString*) radioLink{
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
       // [self changeButtonImg:@"play.png"];
        // Check internet connection
        [self setupInternetConnection];
        // TODO: Make a call to check connectivity
    }
    else{
        NSLog(@"(playRadio) WAS REACHABLE");
        //[self removeInternetErrorMessage];
         [self activateRadioCell: radioLink];
        
    }// End if else
}

- (void) activateRadioCell:(NSString*) link {
    [self displayLoadingScreen:@"Cargando. . . "];
    // Play radio
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", link]]];

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
               // [self changeButtonImg:@"stop.png"];
                
                // Change play flag
                isPlaying = true;
                isPlayingCell0 = true;
                isPlayingCell1 = true;
            }
        });
    });
}


// Center cells in the middle
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * cellWidth) - ((cellCount - 1)*cellSpacing)) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}
// Snap to position
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = 136 + 100; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
    
}
@end





