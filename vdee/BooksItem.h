//
//  BooksItem.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parent.h"
#import "Previous.h"
#import "ChaptersItem.h"
#import "Next.h"

@interface BooksItem : NSObject

@property (nonatomic , copy) NSString *version_id;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *abbr;
@property (nonatomic , copy) NSString *ord;
@property (nonatomic , copy) NSString *book_group_id;
@property (nonatomic , copy) NSString *testament;
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *osis_end;
@property (nonatomic , strong) Parent *parent;
@property (nonatomic , strong) Next *next;
@property (nonatomic , strong) Previous *previous;
@property (nonatomic , copy) NSString *copyright;
@property (nonatomic , strong) NSArray <ChaptersItem *> *chapters;

-(id)initWithId:(NSString*)id version_id:(NSString*)version_id name:(NSString*)name abbr:(NSString*)abbr ord:(NSString*)ord book_group_id:(NSString*)book_group_id testament:(NSString*)testament osis_end:(NSString*)osis_end parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright chapters:(NSArray<ChaptersItem*>*)chapters;

@end
