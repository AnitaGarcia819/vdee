//
//  Books.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooksItem.h"

@interface Books : NSObject

@property (nonatomic, strong) NSArray <BooksItem *> *books;

-(id)initWithBooks:(NSArray<BooksItem*>*)books;

@end
