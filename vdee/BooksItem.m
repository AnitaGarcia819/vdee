//
//  BooksItem.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "BooksItem.h"

@implementation BooksItem

-(id)initWithId:(NSString*)id version_id:(NSString*)version_id name:(NSString*)name abbr:(NSString*)abbr ord:(NSString*)ord book_group_id:(NSString*)book_group_id testament:(NSString*)testament osis_end:(NSString*)osis_end parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright chapters:(NSArray<ChaptersItem*>*)chapters
{
    self = [super init];
    if(self) {
        _id = id;
        _version_id = version_id;
        _name = name;
        _abbr = abbr;
        _ord = ord;
        _book_group_id = book_group_id;
        _testament = testament;
        _osis_end = osis_end;
        _parent = parent;
        _next = next;
        _previous = previous;
        _copyright = copyright;
        _chapters = chapters;
        return self;
    }
    return nil;
}

@end
