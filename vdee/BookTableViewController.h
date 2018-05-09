//
//  BookTableViewController.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooksItem.h"
#import "Book.h"

@interface BookTableViewController : UITableViewController {
    NSString *bookId;
}

@property (nonatomic, strong) NSMutableArray <BooksItem*> *books;

@end
