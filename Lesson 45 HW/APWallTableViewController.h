//
//  APWallTableViewController.h
//  Lesson 45 HW
//
//  Created by Alex on 01.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APUser.h"
#import "APWall.h"

@interface APWallTableViewController : UITableViewController

@property (strong, nonatomic) APUser* user;
@property (strong, nonatomic) APWall* wall;

@end
