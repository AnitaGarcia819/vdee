//
//  Previous.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Previous.h"

@implementation Previous

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

-(id)initWithVerse:(Verse*)verse {
    self = [super init];
    if(self) {
        _verse = verse;
    }
    return nil;
}

@end
