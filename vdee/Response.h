//
//  Response.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooksItem.h"
#import "ChaptersItem.h"
#import "Meta.h"
#import "VersesItem.h"

@interface Response : NSObject

@property (nonatomic , strong) NSArray <BooksItem *> *books;
@property (nonatomic , strong) NSArray <ChaptersItem *> *chapters;
@property (nonatomic , strong) NSArray <VersesItem *> *verses;
@property (nonatomic , strong) Meta *meta;

-(id)initWithBooks:(NSArray<BooksItem*>*)books meta:(Meta*)meta;
-(id)initWithChapters:(NSArray<ChaptersItem*>*)chapters meta:(Meta*)meta;
-(id)initWithVerses:(NSArray<VersesItem*>*)verses meta:(Meta*)meta;

@end
