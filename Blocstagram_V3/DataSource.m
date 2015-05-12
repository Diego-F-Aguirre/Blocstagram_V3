//
//  DataSource.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/5/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "DataSource.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"

@interface DataSource () {

    NSMutableArray *_mediaItems;

}

@property (nonatomic, strong) NSMutableArray *mediaItems;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingOlderItems;


@end


@implementation DataSource


+ (instancetype) sharedInstance {
       static dispatch_once_t once;
       static id sharedInstance;
       dispatch_once(&once, ^{
               sharedInstance = [[self alloc] init];
           });
       return sharedInstance;
    }



- (instancetype) init {
        self = [super init];
    
        if (self) {
                [self addRandomData];
            }
    
        return self;
    }

- (void) addRandomData {
        NSMutableArray *randomMediaItems = [NSMutableArray array];
    
        for (int i = 1; i <= 10; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
                UIImage *image = [UIImage imageNamed:imageName];
        
                if (image) {
                        Media *media = [[Media alloc] init];
                        media.user = [self randomUser];
                        media.image = image;
                        media.caption = [self randomSentence];
            
                        NSUInteger commentCount = arc4random_uniform(10);
                        NSMutableArray *randomComments = [NSMutableArray array];
            
                        for (int i  = 0; i <= commentCount; i++) {
                                Comment *randomComment = [self randomComment];
                                [randomComments addObject:randomComment];
                            }
            
                        media.comments = randomComments;
            
                        [randomMediaItems addObject:media];
                    }
            }
    
        self.mediaItems = randomMediaItems;
    }

- (User *) randomUser {
        User *user = [[User alloc] init];
    
        user.userName = [self randomStringOfLength:arc4random_uniform(10)];
    
        NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
        NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
        user.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
        return user;
    }

- (Comment *) randomComment {
        Comment *comment = [[Comment alloc] init];
    
        comment.from = [self randomUser];
        comment.text = [self randomSentence];
    
        return comment;
    }

- (NSString *) randomSentence {
        NSUInteger wordCount = arc4random_uniform(20);
    
        NSMutableString *randomSentence = [[NSMutableString alloc] init];
    
        for (int i  = 0; i <= wordCount; i++) {
                NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
                [randomSentence appendFormat:@"%@ ", randomWord];
            }
    
        return randomSentence;
    }

- (NSString *) randomStringOfLength:(NSUInteger) len {
        NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
        NSMutableString *s = [NSMutableString string];
        for (NSUInteger i = 0U; i < len; i++) {
                u_int32_t r = arc4random_uniform((u_int32_t)[alphabet length]);
                unichar c = [alphabet characterAtIndex:r];
                [s appendFormat:@"%C", c];
            }
    
        return [NSString stringWithString:s];
    }

- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {

    //#1
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        //#2
        Media *media = [[Media alloc]init];
        media.user = [self randomUser];
        media.image = [UIImage imageNamed:@"10.jpg"];
        media.caption = [self randomSentence];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutableArrayWithKVO insertObject:media atIndex:0 ];
        
        self.isRefreshing = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }

}

- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completonHandler{

    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;
        Media *media = [[Media alloc]init];
        media.user = [self randomUser];
        media.image = [UIImage imageNamed:@"1.jpg"];
        media.caption = [self randomSentence];
        
        NSMutableArray *mutablArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutablArrayWithKVO addObject:media];
        
        self.isLoadingOlderItems = NO;
        
        
        if (completonHandler) {
            completonHandler(nil);
        }
    }
}

#pragma mark - Key/Value Observing

- (NSUInteger) countOfMediaItems {

    return self.mediaItems.count;
}

- (id) objectInMediaItemsAtIndex:(NSUInteger)index {

    return [self.mediaItems objectAtIndex:index];
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {

    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void) insertObject:(Media *)object inMediaItemsAtIndex:(NSUInteger)index {

    [_mediaItems insertObject:object atIndex:index];

}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {

    [_mediaItems removeObjectAtIndex:index];
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {

    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(Media *)item {

    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}


@end
