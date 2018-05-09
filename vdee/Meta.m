//
//  Meta.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "Meta.h"

@implementation Meta

-(id)initWithTId:(NSString*)fums_tid fums:(NSString*)fums fums_js_include:(NSString*)fums_js_include fums_js:(NSString*)fums_js fums_noscript:(NSString*)fums_noscript {
    self = [super init];
    if(self) {
        _fums_tid = fums_tid;
        _fums = fums;
        _fums_js_include = fums_js_include;
        _fums_js = fums_js;
        _fums_noscript = fums_noscript;
    }
    return nil;
}

@end
