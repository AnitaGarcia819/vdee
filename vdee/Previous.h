//
//  Previous.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Chapter.h"
#import "Verse.h"

@interface Previous : NSObject

@property (nonatomic , strong) Book *book;
@property (nonatomic , strong) Chapter *chapter;
@property (nonatomic , strong) Verse *verse;

-(id)initWithBook:(Book*)book;
-(id)initWithChapter:(Chapter*)chapter;
-(id)initWithVerse:(Verse*)verse;

@end
