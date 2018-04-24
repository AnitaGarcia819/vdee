//
//  RadioStationsViewController.m
//  vdee
//
//  Created by Jesus perez on 4/18/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "radioCollectionViewCell.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h> // If using Answers with Crashlytics
//#import <Answers/Answers.h> // If using Answers without Crashlytics

#import "RadioStationsViewController.h"

@interface RadioStationsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *play;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *internetMessage;

@end

@implementation RadioStationsViewController
@synthesize player;
@synthesize playerItem;
@synthesize play_button;
@synthesize internetOutageMessage0;


BOOL isPlayingCell0 = false;
BOOL isPlayingCell1 = false;
BOOL isPlayingCell2 = false;
BOOL isPlayingCell3 = false;
BOOL isPlaying = false;
BOOL isLoading = false;
BOOL noInternet = false;
BOOL wasInterupted = false;
//Reachability *reach;

static NSString * const reuseIdentifier = @"Cell1";

- (BOOL)canBecomeFirstResponder { return YES;}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //The setup code (in viewDidLoad in your view controller)
    
    
    // Check Internet connection
    // Allocate a reachability object (Checks internet connection)
    [self setupInternetConnection];
    
    // Internet error message
    internetOutageMessage0.hidden = TRUE;
    
    
    // Loading view
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(145, 145, 145, 145)];
    self.loadingView.center = CGPointMake(self.radioCollectionView.frame.size.width/2, self.radioCollectionView.frame.size.height/3);
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
    
    
    //Loading label
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
}



- (void) stopRadio{
    // Stops radio
    player.rate = 0.0;
    // Display play image from the stop image that is shown while playing
    // [self changeButtonImg:@"play.png"];
    isPlaying = false;
    isPlayingCell0 = false;
    isPlayingCell1 = false;
    isPlayingCell2 = false;
    isPlayingCell3 = false;
    
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
    [self.activityIndicatorView startAnimating];
    [self.loadingView addSubview:self.loadingLabel];
    [self.radioCollectionView addSubview:self.loadingView];
    self.loadingLabel.text = message;
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
               // [self stopLoadingBox];
               // [self activateRadio];
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
    
    printf("Number of radio stations");
    
    
    
    return 4;
    
}



- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //UICollectionViewCell *cell = (UICollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    static NSString *identifier = @"Cell1";
    //printf("Index Path:", indexPath);
    
    radioCollectionViewCell *cell = (radioCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImage *btnImage = [UIImage imageNamed:@"play.png"];
    //        [btnTwo setImage:btnImage forState:UIControlStateNormal]
    [cell.playButton setImage:btnImage forState:UIControlStateNormal];
    cell.playButton.tag = indexPath.row;
    printf("TAG: %ld \n", (long)indexPath.row);
    
    if(indexPath.row == 0){
        cell.label.text = @"Salinas";
     //  [cell.act stopAnimating];
     
        
        
    }
    else if(indexPath.row == 1){
        cell.label.text = @"King city";
       // [cell.act stopAnimating];
        
    }
    else if(indexPath.row == 2){
        cell.label.text = @"Zion";
       //  [cell.act stopAnimating];
       
        
    }
    else if(indexPath.row == 3){
        cell.label.text = @"Internacional";
        // [cell.act stopAnimating];
       
        
    }
    else{
        printf("Error with accessing the index path");
        
    }
    
    
    
    
    
    return cell;
    
}



//- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //This handling user interaction for the cell itself, so if the user clicks outside the button area it will still detect the item selected.
    
//    radioCollectionViewCell *datasetCell =(radioCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//   // datasetCell.backgroundColor = [UIColor blueColor]; // highlight selection
//    // NSIndexPath* ix = [self.radioCollectionView indexPathForCell: datasetCell];
//    // printf("%ld", (long)ix);
//    NSLog(@"%@", indexPath);
//    NSLog(@"Row: %ld", (long)indexPath.row);
//    NSLog(@"Section: %ld", (long)indexPath.section);
//    if(indexPath.row == 0)
//    {
//
//        printf("Hello 0");
//
//        if (!isPlayingCell0) {
//
//            UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//            //[self playRadioCell:@"http://www.vdee.org:8000/salinas"];
//
//
//
//        }else{
//            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
//            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//            [self stopRadio];
//        }
//
//
//    }
//    else if(indexPath.row == 1)
//    {
//        printf("Hello 1");
//
//        if (!isPlayingCell1) {
//
//            UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//           // [self playRadioCell:@"http://107.215.165.202:8000/resplandecer"];
//
//
//
//        }else{
//            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
//            [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//            [self stopRadio];
//        }
//
//
//    }
//    else if(indexPath.row == 2)
//    {
//        if (!isPlayingCell2) {
//
//            UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//          [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//           // [self playRadioCell:@"http://unoredradio.com:9736/"];
//            //Radio Zion
//            // label.text = @"Radio Zion";
//
//
//
//        }else{
//            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
//           [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//            [self stopRadio];
//        }
//
//    }
//    else if(indexPath.row == 3)
//    {
//
//        if (!isPlayingCell3) {
//
//            UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
//           [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//          //  [self playRadioCell:@"http://162.219.28.116:9638/;"];
//            // Radio Internacional bilingue
//            //label.text = @"Radio Internacional";
//
//
//
//
//
//        }else{
//            UIImage *btnImage = [UIImage imageNamed:@"play.png"];
//         [datasetCell.playButton setImage:btnImage forState:UIControlStateNormal];
//            [self stopRadio];
//        }
//    }
//    else{
//        printf("Error 404");
//
//
//    }
//
//    return datasetCell;
//
//}
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath  {
//
//    radioCollectionViewCell *datasetCell =(radioCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    datasetCell.backgroundColor = [UIColor redColor]; // Default color
//    return datasetCell;
//}
//
-(void) playRadioCell:(NSString*) radioLink: (id) sender{
    // Check for conectivity


    if(!([self setupInternetConnection])){
        NSLog(@"(playRadio) Not ready to play");
        // Let user know no internet connection is established
        [self displayInternetErrorMessage];
        // Stop loading img
        //TODO: Add timer to this
        if(isLoading){
            [self stopLoadingBox];
          //  [cell.act stopAnimating];
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
        [self activateRadioCell: radioLink: sender];

    }// End if else
}

- (void) activateRadioCell:(NSString*) link: (id) sender {
   // [self displayLoadingScreen:@"Cargando. . . "];
    
    
    UIButton *button = (UIButton *)sender;
    radioCollectionViewCell *cell = (radioCollectionViewCell *)[[button superview] superview];
    [cell.act startAnimating];
    
    
    
    
  
    // Play radio
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", link]]];
    NSLog(@"%@", playerItem);
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
                  [cell.act stopAnimating];
                UIImage *btnImage = [UIImage imageNamed:@"stop.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                
                
                // Show stop image
                // [self changeButtonImg:@"stop.png"];
                
                // Change play flag
                isPlaying = true;
                isPlayingCell0 = true;
                isPlayingCell1 = true;
                isPlayingCell2 = true;
                isPlayingCell3 = true;
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
    
    float pageWidth = 174 + 10; // width + space
    
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

- (IBAction)buttonClicked:(id)sender {
    

    UIButton *button = (UIButton *)sender;
    
    switch([sender tag]){
            case 0:
            printf("Hello v0");
            
            if (!isPlayingCell0) {
              

                [self playRadioCell:@"http://www.vdee.org:8000/salinas": sender];
            }else{
               
                UIImage *btnImage = [UIImage imageNamed:@"play.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                [self stopRadio];
                
            }
            
            break;
            case 1:
            printf("Hello v1");

            if (!isPlayingCell1) {
              
                [self playRadioCell:@"http://107.215.165.202:8000/resplandecer": sender ];

            }else{
                UIImage *btnImage = [UIImage imageNamed:@"play.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                [self stopRadio];

            }
            break;
            case 2:
            printf("Hello v2");

            if (!isPlayingCell2) {

                [self playRadioCell:@"http://unoredradio.com:9736/": sender];

            }else{
                
                UIImage *btnImage = [UIImage imageNamed:@"play.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                [self stopRadio];
            }
            break;
            case 3:
            printf("Hello v3");

            if (!isPlayingCell3) {
                [self playRadioCell:@"http://162.219.28.116:9638/;": sender];
               
            }else{
                UIImage *btnImage = [UIImage imageNamed:@"play.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                [self stopRadio];
            }
            break;
        default:
            printf("Error");
            break;
            
    }
}






@end



