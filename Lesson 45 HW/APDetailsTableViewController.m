//
//  APDetailsTableViewController.m
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

//#import "APFriendsListTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APServerManager.h"
#import "APUser.h"
#import "APDetailsTableViewController.h"
#import "APWallTableViewController.h"
#import "APSubsTableViewController.h"
#import "APFollowersTableViewController.h"


@interface APDetailsTableViewController ()

@end

@implementation APDetailsTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getUserDetails];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getUserDetails {
    
    
    [[APServerManager sharedManager] getUserDetailsWithId:self.user.userId
     
     
     
     
     
                                                onSuccess:^(APUser *user) {
                                                    self.user = user;
                                                    NSLog(@"user name %@, %@", self.user.firstName, self.user.lastName);
                                                    
                                                    [self.tableView beginUpdates];
                                                    
                                                    self.nameLabel.text = self.user.firstName;
                                                    
                                                    
                                                    NSLog(@"site and followers count is %@ %@", self.user.site, self.user.followersCount);
                                                    
                                                    self.lastNameLabel.text = self.user.lastName;
                                                    
                                                    if (self.user.site.length > 1) {
                                                        self.cityLabel.text = [NSString stringWithFormat:@"%@", self.user.site];
                                                    } else {
                                                        self.cityLabel.text = @"No web-sites";
                                                    }
                                                    
                                                    
                                                    self.countryLabel.text = [NSString stringWithFormat:@"Followers count - %@", self.user.followersCount];
                                                    
                                                    
                                                    NSURLRequest* request = [NSURLRequest requestWithURL:self.user.image200URL];
                                                    
                                                    self.photoBigImageView.image = nil;
                                                    
                                                    [self.photoBigImageView setImageWithURLRequest:request //method from "UIImageView+AFNetworking.h"
                                                                                  placeholderImage:nil
                                                                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                               self.photoBigImageView.image = image;
                                                                                               
                                                                                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                                                               NSLog(@"ERROOORR FAILURE IMAGE");
                                                                                           }];
                                                    
                                                    
                                                    [self.tableView endUpdates];
                                                    
                                                    
                                                }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
                                                    NSLog(@"errorr = %@", [error localizedDescription]);
                                                }];
    
}




#pragma mark - Table view data source

#pragma mark - Actions

- (IBAction)subsBarButtonAction:(UIBarButtonItem *)sender {
    
    UIStoryboard* storyboard = self.storyboard;
    APSubsTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"APSubsTableViewController"];
    
    vc.user = self.user;    
    
    
   // NSLog(@"name is - %@", clickedFriend.firstName);
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)followersBarButtonAction:(UIBarButtonItem *)sender {
    
    UIStoryboard* storyboard = self.storyboard;
    APFollowersTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"APFollowersTableViewController"];
    
    vc.user = self.user;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)wallBarButtonAction:(UIBarButtonItem *)sender {
    
    UIStoryboard* storyboard = self.storyboard;
    APWallTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"APWallTableViewController"];
    vc.user = self.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
