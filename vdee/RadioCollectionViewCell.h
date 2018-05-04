//
//  radioCollectionViewCell.h
//  vdee
//
//  Created by Jesus perez on 4/18/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface radioCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingMessage;
@end

