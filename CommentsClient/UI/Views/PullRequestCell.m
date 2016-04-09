//
//  PullRequestCell.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "PullRequestCell.h"
#import "PullRequest.h"
#import "User.h"
#import "CurrentUser.h"

@interface PullRequestCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaInfoLabel;
@end

@implementation PullRequestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setupPullRequest:(PullRequest *)pullRequest {
    self.titleLabel.text = pullRequest.title;
    
    NSString *dateString = pullRequest.createdAtString;
    NSString *usernameString = [pullRequest.user.userID isEqual:[CurrentUser currentUser].userID] ? @"you" : pullRequest.user.login;
    self.metaInfoLabel.text = [NSString stringWithFormat:@"#%d created by %@ at %@", pullRequest.number.intValue, usernameString, dateString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
