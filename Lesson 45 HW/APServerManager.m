//
//  APServerManager.m
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APServerManager.h"
#import "AFNetworking.h"
#import "APWall.h"


@interface APServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager; //this is from AFN 3.0

@end

@implementation APServerManager

+ (APServerManager*) sharedManager {
    
    static APServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        // http://vk.com/dev/api_requests
        
        NSURL *URL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
        
    }
    return self;
}

#pragma mark - Methods API

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                     onSucces:(void (^)(NSArray *))succes
                    onFailure:(void (^)(NSError *, NSInteger))failure {
    
    // params we get from http://vk.com/dev/friends.get
    NSDictionary* params =   [NSDictionary dictionaryWithObjectsAndKeys:
                              @"1",  @"user_id",
                              @"name",       @"order",
                              @(count),      @"count",
                              @(offset),     @"offset",
                              @"photo_50",   @"fields",
                              @"nom",        @"name_case",
                              nil];
    
    // AFN 3 is changed, so new code is here https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         NSLog(@"JSON: %@", responseObject);
                         NSArray* dictsArray = [responseObject objectForKey:@"response"]; // из JSON данные приходят с стартом стринги response
                         NSMutableArray* objectsArray = [[NSMutableArray alloc] init];
                         for (NSDictionary* dict in dictsArray) {
                             APUser* user =[[APUser alloc] initWithServerResponse:dict];
                             [objectsArray addObject:user];//все что пришло из ВК мы положили в массив
                         }
                         if (succes) { // запустили блок-метод из контроллера, передав ему массив с данными из вк
                             succes (objectsArray);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, operation.response.expectedContentLength);
                         }
                     }];
    
    
}


- (void) getUserSubscriptions:(NSString*) userID
                withSubsCount:(NSInteger) count
                    onSuccess:(void(^)(NSMutableArray* subscriptionsInfo)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    //   http://vk.com/dev/users.getSubscriptions
    //    user_id userID
    //    fields photo_100,name
    //    extended 1
    //    count 20
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"user_id",
                            @"photo_100,name", @"fields",
                            @(1), @"extended",
                            @(0), @"offset",
                            @(count), @"count", nil];
    
    
    
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         NSArray* userInfo = [responseObject objectForKey:@"response"];
                         
                         NSMutableArray* subsAndPhoto = [NSMutableArray array];
                         
                         for (NSDictionary* dict in userInfo) {
                             
                             NSString* name = [dict objectForKey:@"name"];
                             id photo = [dict objectForKey:@"photo_100"];
                             
                             NSDictionary* resultDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", photo, @"photo_100", nil];
                             
                             [subsAndPhoto addObject:resultDict];
                             
                         }
                         
                         if (success) {
                             
                             success(subsAndPhoto);
                             
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, operation.response.expectedContentLength);
                         }
                     }];
    
}

- (void) getUserFollowers:(NSString*) userID withFolCount:(NSInteger) count onSuccess:(void(^)(NSMutableArray* followersInfo)) success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    // http://vk.com/dev/users.getFollowers
    //    user_id userID
    //    fields photo_100
    //    count 50
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"user_id",
                            @"photo_100", @"fields",
                            @(0), @"offset",
                            @(count), @"count", nil];
    
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         NSMutableArray* userInfo = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray* follsAndPhoto = [NSMutableArray array];
                         
                         for (NSDictionary* dict in userInfo) {
                             
                             NSString* name = [dict objectForKey:@"first_name"];
                             NSString* surname = [dict objectForKey:@"last_name"];
                             id photo = [dict objectForKey:@"photo_100"];
                             
                             NSString* initials = [NSString stringWithFormat:@"%@ %@", name, surname];
                             
                             NSDictionary* resultDict = [NSDictionary dictionaryWithObjectsAndKeys:initials, @"initials", photo, @"photo_100", nil];
                             
                             [follsAndPhoto addObject:resultDict];
                             
                         }
                         
                         if (success) {
                             
                             success(follsAndPhoto);
                             
                         
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, operation.response.expectedContentLength);
                         }
                     }];
    
    

    
}

- (void) getUserWall:(NSString*) userID withWallOffset:(NSInteger) offset wallCount:(NSInteger) count onSuccess:(void(^)(NSMutableArray* wallArray)) success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    //    http://vk.com/dev/wall.get
    //    owner_id userID
    //    offset @(offset)
    //    count @(count)
    //    filter owner
    //    extended 1
    //    fields name,photo_50
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"owner_id",
                            @(offset), @"offset",
                            @(count), @"count",
                            @"owner", @"filter",
                            @(0), @"extended",
                            @"photo_50,name", @"fields", nil];
    
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         
                         //NSLog(@"JSON: %@", responseObject);
                         
                         NSMutableArray* userInfo = [responseObject objectForKey:@"response"];
                         
                         NSMutableArray* wallArray = [NSMutableArray array];
                         
                         if ([userInfo count] <= 1) {
                             
                             NSDictionary* errorDict = [NSDictionary dictionaryWithObject:@"error" forKey:@"wallError"];
                             
                             APWall* wall = [[APWall alloc] initWithDictionary:errorDict];
                             
                             [wallArray addObject:wall];
                             
                         } else {
                             
                             for (NSDictionary* dict in userInfo) {
                                 
                                 if (![dict isEqual:[userInfo firstObject]]) {
                                     
                                     APWall* postInfo = [[APWall alloc] initWithDictionary:dict];
                                     
                                     [wallArray addObject:postInfo];
                                     
                                 }
                                 
                             }
                             
                         }
                         
                         if (success) {
                             
                             success(wallArray);
                             
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, operation.response.expectedContentLength);
                         }
                     }];
    
    

    
}


- (void) getUserDetailsWithId:(NSString*) userID onSuccess:(void(^)(APUser* user)) success onFailure:(void(^)(NSError*, NSInteger)) failure {
    
    //  got params from vk.com/dev/users.get
    //    user_ids userID
    //    fields photo_200,city,country,photo_50
    //    name_case nom
    
    // Добавить статус online или offline
    
    // init - key - userInfoForProfile
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"user_ids",
                            @"photo_200,photo_50,site,followers_count,online", @"fields",
                            @"nom", @"name_case",
                            nil];
    
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray* userInfo = [responseObject objectForKey:@"response"];
                         
                         for (NSDictionary* dict in userInfo) {
                             
                             APUser* user = [[APUser alloc] initWithServerResponse:dict];
                             
                             if (success) {
                                 
                                 success(user);
                                 
                             }
                             
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, task.response.expectedContentLength);
                         }
                         
                     }];
    
    
    
}

@end
