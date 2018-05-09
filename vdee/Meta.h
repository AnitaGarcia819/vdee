//
//  Meta.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meta : NSObject

@property (nonatomic , copy) NSString *fums;
@property (nonatomic , copy) NSString *fums_tid;
@property (nonatomic , copy) NSString *fums_js_include;
@property (nonatomic , copy) NSString *fums_js;
@property (nonatomic , copy) NSString *fums_noscript;

-(id)initWithTId:(NSString*)fums_tid fums:(NSString*)fums fums_js_include:(NSString*)fums_js_include fums_js:(NSString*)fums_js fums_noscript:(NSString*)fums_noscript;

@end
