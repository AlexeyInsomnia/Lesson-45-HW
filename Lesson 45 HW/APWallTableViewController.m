//
//  APWallTableViewController.m
//  Lesson 45 HW
//
//  Created by Alex on 01.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APWallTableViewController.h"
#import "APServerManager.h"

#import "APWallTableViewCell.h"
#import "APWall.h"

@interface APWallTableViewController ()

@property (strong, nonatomic) NSMutableArray* wallArray;

@end


const static NSInteger wallPostsCount = 10;
const static NSInteger contsPostImageWidth = 320;


@implementation APWallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wallArray = [NSMutableArray array];
    
    [self getUserWall];
    
    NSLog(@"WALL - %@", self.user.firstName);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API methods

- (void) getUserWall {
    
    
    [[APServerManager sharedManager] getUserWall:self.user.userId
                                  withWallOffset:[self.wallArray count]
                                       wallCount:wallPostsCount
                                       onSuccess:^(NSMutableArray *wallArray) {
                                           
                                           
                                          
                                           
                                           self.wallArray = wallArray;
                                           NSInteger objects = 0;
                                           
                                           for (APWall* wallPost in self.wallArray) {
                                               
                                               NSData* dataPostImage = [[NSData alloc] initWithContentsOfURL:wallPost.postImageURL];
                                               
                                               wallPost.postImage = [UIImage imageWithData:dataPostImage];
                                               
                                               if (self.user.image50URL != nil) {
                                                   
                                                   NSData* dataUserImage = [[NSData alloc] initWithContentsOfURL:self.user.image50URL];
                                                   wallPost.userImage = [UIImage imageWithData:dataUserImage];
                                                   
                                                   objects++;
                                                   
                                               }
                                         
                                               
                                           }
                                    [self.tableView reloadData];
                                       }
                                       onFailure:^(NSError *error, NSInteger statusCode) {
                                           NSLog(@"FAILED TO LOAD USER WALL");
                                       }];
    
        

    
}


- (NSString*) removeHTMLTags:(NSString*) string {
    
    NSRange r;
    
    if (string != nil) {
        
        while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            
            string = [string stringByReplacingCharactersInRange:r withString:@" "];
        }
        
    }
    
    return string;
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return [self.wallArray count]; // записи на стене.
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* title;
    
    if ([self.wallArray count] == 1) {
        
        title = @"Стена закрыта";
        
    }
    
    return title;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString* identifierWall = @"wallCell";
    static NSString* identifierError = @"errorCell";
    
    APWall* wallPost = [self.wallArray objectAtIndex:indexPath.row];
    
    if ([wallPost.wallError isEqualToString:@"error"]) {
        
        
        UITableViewCell* errorCell = [tableView dequeueReusableCellWithIdentifier:identifierError];
        
        if (!errorCell) {
            
            errorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierError];
            
        }
        
        errorCell.textLabel.text = @"Доступ к записям ограничен";
        
        return errorCell;
        
    } else {
        
        
        APWallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierWall];
        
        cell.nameSurnameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        cell.postDateLabel.text = wallPost.postDate;
        cell.postTextLabel.text = [self removeHTMLTags:wallPost.postText];
        NSLog(@"%@",cell.postTextLabel.text);
        cell.postTitleLabel.text = [self removeHTMLTags:wallPost.postTitle];
        NSLog(@"%@",cell.postTitleLabel.text);
        cell.commentsCountLabel.text = wallPost.commentsCount;
        cell.repostsCountLabel.text = wallPost.repostsCount;
        cell.likesCountLabel.text = wallPost.likesCount;
        
        cell.avatarImage.image = wallPost.userImage;
        
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.height / 2;
        
        cell.avatarImage.layer.masksToBounds = YES;
        
        cell.avatarImage.layer.borderWidth = 0;
        
        if (wallPost.postImage != nil) {
            
           
            CGFloat proportionalHeight = (float)(wallPost.postImage.size.height / wallPost.postImage.size.width) * contsPostImageWidth;
            
            cell.postImage.image = [self imageWithImage:wallPost.postImage convertToSize:CGSizeMake(contsPostImageWidth, proportionalHeight)];
            
        } else {
            
            cell.postImage.image = wallPost.postImage;
            
        }
        
        return cell;
}


}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 540.f;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

@end
