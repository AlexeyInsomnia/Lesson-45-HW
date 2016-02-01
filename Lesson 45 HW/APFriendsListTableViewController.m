//
//  APFriendsListTableViewController.m
//  Lesson 45 HW
//
//  Created by Alex on 31.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APFriendsListTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APServerManager.h"
#import "APUser.h"
#import "APDetailsTableViewController.h"

@interface APFriendsListTableViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end

@implementation APFriendsListTableViewController

static NSInteger friendsInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [[NSMutableArray alloc] init];
    
    [self getFriendsFromServer];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - API

- (void) getFriendsFromServer {
    
    
    [[APServerManager sharedManager]getFriendsWithOffset:[self.friendsArray count]
                                                   count:friendsInRequest
                                                onSucces:^(NSArray *friends) {
                                                    
                                                    [self.friendsArray addObjectsFromArray:friends]; //получили данные из ВК, запрошенные через синглтон
                                                    
                                                    NSMutableArray* newPaths = [[NSMutableArray alloc] init];
                                                    
                                                    for (int i=(int)[self.friendsArray count] - (int)[friends count]; i<[self.friendsArray count]; i++) {
                                                        [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]]; // массив из рядов создали
                                                    }
                                                    
                                                    [self.tableView beginUpdates];
                                                    
                                                    [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop]; //положили в тейблвью все строки
                                                    
                                                    [self.tableView endUpdates];
                                                    
                                                }
                                               onFailure:^(NSError *error, NSInteger statucCode) {
                                                   NSLog(@"errorr = %@, code = %ld", [error localizedDescription], statucCode);
                                               }];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friendsArray count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        cell.textLabel.text = @"LOAD MORE"; // выделяем нижнюю строку
        cell.imageView.image = nil;
    } else {
        
        APUser* friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        

        

   
        NSURLRequest* request = [NSURLRequest requestWithURL:friend.image50URL];
        
        __weak UITableViewCell* weakCell = cell; // __weak - because BLOCK
        
        cell.imageView.image = nil;
        
        [cell.imageView setImageWithURLRequest:request //method from "UIImageView+AFNetworking.h"
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           weakCell.imageView.image = image;
                    
                                           [weakCell layoutSubviews];
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           NSLog(@"ERROOORR FAILURE IMAGE");
                                       }];
        
        
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.friendsArray count]) {
        [self getFriendsFromServer];
    } else {
        
        //APDetailsTableViewController* vc =[[APDetailsTableViewController alloc] init]; // вариант пустого инита
        
        // вариант инита с даными из сториборда
        
        
        
        UIStoryboard* storyboard = self.storyboard;
        APDetailsTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"APDetailsTableViewController"];
        
        APUser* clickedFriend = [self.friendsArray objectAtIndex:indexPath.row];
        
        vc.user = clickedFriend;
        
        NSLog(@"name is - %@", clickedFriend.firstName);
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
        // вариант инита из сториборда при помощи сигвей, которую то этого поставили в ПУШ (гораздо проще работает с статическими чем динамическими)
        // в статической ячейке не надо этот метод, а в данном случае она не активируется без.
        
        //[self performSegueWithIdentifier:@"showProfile" sender:indexPath];
        
        
        
        
    }
    
    
    
}


@end
