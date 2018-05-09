//
//  Parent.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Parent.h"

@implementation Parent

-(id)initWithVersion:(Version*)version {
    self = [super init];
    if(self) {
        _version = version;
    }
    return nil;
}

-(id)initWithBook:(Book*)book {
    self = [super init];
    if(self) {
        _book = book;
    }
    return nil;
}

-(id)initWithChapter:(Chapter*)chapter {
    self = [super init];
    if(self) {
        _chapter = chapter;
    }
    return nil;
}

@end
