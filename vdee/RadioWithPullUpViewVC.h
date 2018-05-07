//
//  RadioWithPullUpViewVC.h
//  vdee
//
//  Created by Nicholas Rosas on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ISHPullUp;

@interface RadioWithPullUpViewVC : UIViewController <ISHPullUpContentDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIView *rootView;


@end
