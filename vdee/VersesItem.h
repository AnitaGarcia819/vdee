//
//  VersesItem.h
//  vdee
//
//  Created by Brittany Arnold on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Previous.h"
#import "Next.h"
#import "Parent.h"

@interface VersesItem : NSObject

@property (nonatomic , copy) NSString *auditid;
@property (nonatomic , copy) NSString *verse;
@property (nonatomic , copy) NSString *lastverse;
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *osis_end;
@property (nonatomic , copy) NSString *label;
@property (nonatomic , copy) NSString *reference;
@property (nonatomic , copy) NSString *prev_osis_id;
@property (nonatomic , copy) NSString *next_osis_id;
@property (nonatomic , copy) NSString *text;
@property (nonatomic , strong) Parent *parent;
@property (nonatomic , strong) Next *next;
@property (nonatomic , strong) Previous *previous;
@property (nonatomic , copy) NSString *copyright;

-(id)initWithId:(NSString*)id auditid:(NSString*)auditid verse:(NSString*)verse lastverse:(NSString*)lastverse osis_end:(NSString*)osis_end label:(NSString*)label reference:(NSString*)reference prev_osis_end:(NSString*)prev_osis_end next_osis_end:(NSString*)next_osis_end text:(NSString*)text parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright;

@end
