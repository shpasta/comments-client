//
//  CommentCell.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "User.h"
#import "CurrentUser.h"

@interface CommentCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaInfoLabel;
@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setupComment:(Comment *)comment {
    self.titleLabel.text = comment.body;
    
    NSString *dateString = comment.createdAtString;
    NSString *usernameString = [comment.user.userID isEqual:[CurrentUser currentUser].userID] ? @"you" : comment.user.login;
    self.metaInfoLabel.text = [NSString stringWithFormat:@"by %@ at %@", usernameString, dateString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
