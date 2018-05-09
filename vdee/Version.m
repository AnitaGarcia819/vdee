//
//  Version.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Version.h"

@implementation Version

-(id)initWithId:(NSString*)id path:(NSString*)path name:(NSString*)name {
    self = [super init];
    if(self) {
        _id = id;
        _path = path;
        _name = name;
        return self;
    }
    return nil;
}

@end
