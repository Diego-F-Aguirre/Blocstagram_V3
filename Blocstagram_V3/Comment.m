//
//  Comment.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/5/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "Comment.h"
#import "User.h"


@implementation Comment

- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary{

    self = [super init];
    
    if (self) {
        self.idNumber = commentDictionary[@"id"];
        self.text = commentDictionary[@"text"];
        self.from = [[User alloc]initWithDictionary:commentDictionary[@"from"]];
    }
    
    return self;
}

@end
