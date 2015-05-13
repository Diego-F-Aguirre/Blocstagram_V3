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
#import "LoginViewController.h"

@interface DataSource () {

    NSMutableArray *_mediaItems;

}

@property (nonatomic, strong) NSString *accessToken;
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
                [self registerForAccessTokenNotification];
            }
    
        return self;
    }

- (void) registerForAccessTokenNotification {

    [[NSNotificationCenter defaultCenter] addObserverForName:LoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.accessToken = note.object;
        
        // Got a token; populate the initial data
        [self populateDataWithParameters:nil];
    }];
}




- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {

    //#1
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        //#2
        //ToDo: Add images
        
        self.isRefreshing = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }

}

- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completonHandler{

    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;
      
        //ToDo: Add images
        
        self.isLoadingOlderItems = NO;
        
        
        if (completonHandler) {
            completonHandler(nil);
        }
    }
}

+ (NSString *)instagramClientID{

    return @"98e88b70a66e4a7db41446637956d86e";
}

- (void)populateDataWithParameters:(NSDictionary *)parameters {

    if (self.accessToken) {
        // only try to get the data if there's an access token
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // do the network request in the background, so the UI doesn't lock up
            
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
            
            for (NSString *parameterName in parameters){
            
            // for example, if dictionary contains {count: 50}, append `&count=50` to the URL
                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];

            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLResponse *response;
                NSError *webError;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
                
                if (responseData) {
                    NSError *jsonError;
                    NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                    
                    if (feedDictionary) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        // done networking, go back on the main thread
                            [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
                            
                        });
                    }
                }
            }

        });

    }
}

- (void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
        NSLog(@"%@", feedDictionary);
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
