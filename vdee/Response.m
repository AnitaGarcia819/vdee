//
//  Response.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Response.h"

@implementation Response

-(id)initWithBooks:(NSArray<BooksItem*>*)books meta:(Meta*)meta {
    self = [super init];
    if(self) {
        _books = books;
        _meta = meta;
        return self;
    }
    return nil;
}

-(id)initWithChapters:(NSArray<ChaptersItem*>*)chapters meta:(Meta*)meta {
    self = [super init];
    if(self) {
        _chapters = chapters;
        _meta = meta;
    }
    return nil;
}

-(id)initWithVerses:(NSArray<VersesItem*>*)verses meta:(Meta*)meta {
    self = [super init];
    if(self) {
        _verses = verses;
        _meta = meta;
    }
    return nil;
}

@end
