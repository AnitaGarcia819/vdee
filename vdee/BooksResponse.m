//
//  BooksResponse.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "BooksResponse.h"

@implementation BooksResponse

-(id)initWithResponse:(Response *)response {
    self = [super init];
    if(self) {
        _response = response;
        return self;
    }
    return nil;
}

@end
