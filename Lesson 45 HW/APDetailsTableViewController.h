//
//  APDetailsTableViewController.h
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APUser.h"

@interface APDetailsTableViewController : UITableViewController

@property (strong, nonatomic) APUser* user;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoBigImageView;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
- (IBAction)subsBarButtonAction:(UIBarButtonItem *)sender;
- (IBAction)followersBarButtonAction:(UIBarButtonItem *)sender;
- (IBAction)wallBarButtonAction:(UIBarButtonItem *)sender;

@end
