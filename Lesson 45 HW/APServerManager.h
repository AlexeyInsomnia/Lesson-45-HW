//
//  APServerManager.h
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APUser.h"

@interface APServerManager : NSObject

+ (APServerManager*) sharedManager; // make it as a singletone

// now making method for VK method

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                     onSucces:(void(^)(NSArray* friends)) succes
                    onFailure:(void(^)(NSError* error, NSInteger statucCode)) failure;


- (void) getUserDetailsWithId:(NSString*) userID
                    onSuccess:(void(^)(APUser* user))success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


- (void) getUserSubscriptions:(NSString*) userID
                withSubsCount:(NSInteger) count
                    onSuccess:(void(^)(NSMutableArray* subscriptionsInfo)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUserFollowers:(NSString*) userID
             withFolCount:(NSInteger) count
                onSuccess:(void(^)(NSMutableArray* followersInfo)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUserWall:(NSString*) userID
      withWallOffset:(NSInteger) offset
           wallCount:(NSInteger) count
           onSuccess:(void(^)(NSMutableArray* wallArray)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
