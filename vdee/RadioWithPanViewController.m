//
//  RadioWithPanViewController.m
//  vdee
//
//  Created by Nicholas Rosas on 5/3/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "RadioWithPanViewController.h"

@interface RadioWithPanViewController ()

@end

@implementation RadioWithPanViewController

@synthesize trayView;

CGPoint trayOriginalCenter;
CGFloat trayDownOffset;
CGPoint trayUp;
CGPoint trayDown;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trayDownOffset = 160;
    trayUp = trayView.center;
    trayDown = CGPointMake(trayView.center.x, trayView.center.y + trayDownOffset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPanTray:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView: self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        trayOriginalCenter = trayView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        trayView.center = CGPointMake(trayOriginalCenter.x, trayOriginalCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            
        } else {
            
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
