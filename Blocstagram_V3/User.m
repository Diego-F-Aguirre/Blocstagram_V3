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

#pragma mark -  NSCoding

- (instancetype) initWithCoder:(NSCoder *)aDecoder{

    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.userName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userName))];
        self.fullName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fullName))];
        self.profilePicture = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(profilePicture))];
        self.profilePictureURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(profilePictureURL))];
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.userName forKey:NSStringFromSelector(@selector(userName))];
    [aCoder encodeObject:self.fullName forKey:NSStringFromSelector(@selector(fullName))];
    [aCoder encodeObject:self.profilePicture forKey:NSStringFromSelector(@selector(profilePicture))];
    [aCoder encodeObject:self.profilePictureURL forKey:NSStringFromSelector(@selector(profilePictureURL))];
    
}

@end
