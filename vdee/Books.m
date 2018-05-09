//
//  Books.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Books.h"

@implementation Books

-(id)initWithBooks:(NSArray<BooksItem*>*)books {
    self = [super init];
    if(self) {
        _books = books;
        return self;
    }
    return nil;
}

@end
