//
//  Parent.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version.h"
#import "Book.h"
#import "Chapter.h"

@interface Parent : NSObject

@property (nonatomic , strong) Version *version;
@property (nonatomic , strong) Book *book;
@property (nonatomic , strong) Chapter *chapter;

-(id)initWithVersion:(Version*)version;
-(id)initWithBook:(Book*)book;
-(id)initWithChapter:(Chapter*)chapter;

@end
