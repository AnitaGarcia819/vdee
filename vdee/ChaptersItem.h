//
//  ChaptersItem.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parent.h"
#import "Next.h"
#import "Previous.h"

@interface ChaptersItem : NSObject

@property (nonatomic , copy) NSString *auditid;
@property (nonatomic , copy) NSString *label;
@property (nonatomic , copy) NSString *chapter;
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *osis_end;
@property (nonatomic , strong) Parent *parent;
@property (nonatomic , strong) Next *next;
@property (nonatomic , strong) Previous *previous;
@property (nonatomic , copy) NSString *copyright;

-(id)initWithId:(NSString*)id auditid:(NSString*)auditid label:(NSString*)label chapter:(NSString*)chapter osis_end:(NSString*)osis_end parent:(Parent*)parent next:(Next*)next previous:(Previous*)previous copyright:(NSString*)copyright;


@end
