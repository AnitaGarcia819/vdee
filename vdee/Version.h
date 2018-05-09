//
//  Version.h
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Version : NSObject

@property (nonatomic , copy) NSString *path;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *id;

-(id)initWithId:(NSString*)id path:(NSString*)path name:(NSString*)name;


@end
