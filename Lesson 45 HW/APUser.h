//
//  APUser.h
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

// Класс создан для удобства обработки JSON из GET запроса

@interface APUser : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* image50URL;

@property (strong, nonatomic) NSString* userId;


@property (assign, nonatomic) BOOL isOnline;

@property (strong, nonatomic) NSURL* image100URL;

@property (strong, nonatomic) NSURL* image200URL;

@property (strong, nonatomic) NSString* followersCount;
@property (strong, nonatomic) NSString* site;


- (id) initWithServerResponse:(NSDictionary*) responseObject;


@end






