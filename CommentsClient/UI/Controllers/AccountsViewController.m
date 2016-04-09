//
//  AccountsViewController.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "AccountsViewController.h"
#import "SessionManager.h"
#import "PullRequest.h"
#import "CurrentUser.h"
#import "Constants.h"

#import <MagicalRecord/MagicalRecord.h>



@interface AccountsViewController ()
@end

@implementation AccountsViewController

- (instancetype)init {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - UITableView Datasource & Delegate -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([[CurrentUser currentUser].userID isEqual:UserIDs[indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [CurrentUser currentUser].userID = UserIDs[indexPath.row];
    [CurrentUser currentUser].accessToken = UserAccessTokens[indexPath.row];
    [self.tableView reloadData];
}

- (IBAction)actionDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Delete all PullRequest entities in main thread
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PullRequest"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] executeRequest:delete withContext:[NSManagedObjectContext MR_defaultContext] error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Comment"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] executeRequest:delete withContext:[NSManagedObjectContext MR_defaultContext] error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] executeRequest:delete withContext:[NSManagedObjectContext MR_defaultContext] error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Label"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] executeRequest:delete withContext:[NSManagedObjectContext MR_defaultContext] error:&deleteError];

    if ([self.delegate respondsToSelector:@selector(didChangeAccount:)])
        [self.delegate didChangeAccount:self];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
