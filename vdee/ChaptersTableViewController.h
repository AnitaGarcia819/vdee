//
//  ChaptersTableViewController.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChaptersItem.h"
#import "BookTableViewController.h"

@interface ChaptersTableViewController : UITableViewController {
    NSString *chapterNumber;
    NSString *bookId;
}

@property (nonatomic, strong) NSMutableArray <ChaptersItem*> *chapters;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *chaptersURL;

@end
