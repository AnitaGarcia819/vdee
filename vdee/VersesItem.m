//
//  VersesItem.m
//  vdee
//
//  Created by Brittany Arnold on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "VersesItem.h"

@implementation VersesItem

-(id)initWithId:(NSString*)id auditid:(NSString*)auditid verse:(NSString*)verse lastverse:(NSString*)lastverse osis_end:(NSString*)osis_end label:(NSString*)label reference:(NSString*)reference prev_osis_end:(NSString*)prev_osis_end next_osis_end:(NSString*)next_osis_end text:(NSString*)text parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright {
    self = [super init];
    if(self) {
        _id = id;
        _auditid = auditid;
        _verse = verse;
        _lastverse = lastverse;
        _osis_end = osis_end;
        _label = label;
        _reference = reference;
        _prev_osis_id = prev_osis_end;
        _next_osis_id = next_osis_end;
        _text = text;
        _parent = parent;
        _next = next;
        _previous = previous;
        _copyright = copyright;
    }
    return nil;
}

@end
