//
//  APUser.m
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APUser.h"

@implementation APUser

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.userId = [responseObject objectForKey:@"uid"];
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey: @"photo_50"];
        
        if (urlString) {
            self.image50URL = [NSURL URLWithString:urlString];
        }
        
        // Парсинг responseObject - ответа с сервера
        
        self.isOnline = [[responseObject objectForKey:@"online"] boolValue];
        
        self.followersCount = [responseObject objectForKey:@"followers_count"];
        self.site = [responseObject objectForKey:@"site"];
        
        NSString* urlString_100 = [responseObject objectForKey:@"photo_100"];
        NSString* urlString_200 = [responseObject objectForKey:@"photo_200"];
        
        self.image100URL = [NSURL URLWithString:urlString_100];
        self.image200URL = [NSURL URLWithString:urlString_200];
        
    }
    return self;
}


@end
