//
//  BooksResponse.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface BooksResponse : NSObject

@property (nonatomic , strong) Response *response;

-(id)initWithResponse:(Response*)response;

@end
