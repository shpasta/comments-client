//
//  AccountsViewController.h
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountsViewControllerDelegate;

@interface AccountsViewController : UITableViewController

@property (nonatomic, weak) id<AccountsViewControllerDelegate> delegate;

@end

@protocol AccountsViewControllerDelegate <NSObject>

// Account View Controller Did Change Account
- (void)didChangeAccount:(AccountsViewController *)viewController;

@end
