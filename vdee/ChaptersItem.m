//
//  ChaptersItem.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "ChaptersItem.h"

@implementation ChaptersItem

-(id)initWithId:(NSString*)id auditid:(NSString*)auditid label:(NSString*)label chapter:(NSString*)chapter osis_end:(NSString*)osis_end parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright {
    self = [super init];
    if(self) {
        _id = id;
        _auditid = auditid;
        _label = label;
        _chapter = chapter;
        _osis_end = osis_end;
        _parent = parent;
        _next = next;
        _previous = previous;
        _copyright = copyright;
        return self;
    }
    return nil;
}

@end
