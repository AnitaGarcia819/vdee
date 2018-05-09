//
//  VersesTableViewController.h
//  vdee
//
//  Created by Brittany Arnold on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChaptersTableViewController.h"
#import "BookTableViewController.h"
#import "VersesItem.h"

@interface VersesTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<VersesItem*> *verses;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *chapterNumber;
@property (nonatomic, strong) NSString *versesURL;

@end
