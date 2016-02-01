//
//  APFollowersTableViewController.m
//  Lesson 45 HW
//
//  Created by Alex on 01.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APFollowersTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APServerManager.h"

@interface APFollowersTableViewController ()

@property (strong, nonatomic) NSMutableArray* followersInfoArray;

@end

@implementation APFollowersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followersInfoArray = [NSMutableArray array];
    
    NSString* count = self.user.followersCount;
    
    [self getUserFollowers:[count intValue]]; //берем количество фолловерсов
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API methods

- (void) getUserFollowers:(NSInteger) count {
    
    [[APServerManager sharedManager] getUserFollowers:self.user.userId withFolCount:count onSuccess:^(NSMutableArray *followersInfo) {
        
        self.followersInfoArray = followersInfo;
        
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        NSLog(@"FAILED TO LOAD subscriptionsInfo");
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.followersInfoArray count] != 0) {
        
        return 1;
        
    } else {
        
        return 0;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.followersInfoArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    NSDictionary* folInfo = [self.followersInfoArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = (NSString*)[folInfo objectForKey:@"initials"];
    
    NSString* urlString = (NSString*)[folInfo objectForKey:@"photo_100"];
    
    NSURL* imageURL = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:imageURL];
    
    cell.imageView.image = nil;
    
    __weak UITableViewCell* weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakCell.imageView.image = image; // вывод картинки
        
        [weakCell layoutSubviews];
        
        // Делаем закругленную аватарку
        weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.height / 2;
        
        weakCell.imageView.layer.masksToBounds = YES;
        
        weakCell.imageView.layer.borderWidth = 0;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"FAILED TO LOAD THE IMAGE");
        
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
    
}

@end
