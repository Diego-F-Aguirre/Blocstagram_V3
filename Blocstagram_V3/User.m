//
//  User.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/5/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)userDictionary{

    self = [super init];
    
    if (self) {
        self.idNumber = userDictionary[@"id"];
        self.userName = userDictionary[@"username"];
        self.fullName = userDictionary[@"full_name"];
        
        NSString *profileURLString = userDictionary[@"profile_picture"];
        NSURL *profileUrl = [NSURL URLWithString:profileURLString];
        
        if (profileUrl) {
            self.profilePictureURL = profileUrl;
        }
    }
    
    return self;
}

@end
