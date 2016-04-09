//
//  CommentsViewController.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/5/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "CommentsViewController.h"
#import "Comment.h"
#import "Label.h"
#import "CommentCell.h"
#import "PullRequest.h"
#import "User.h"
#import "NewCommentViewController.h"
#import "SessionManager.h"

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    PullRequest *_pullRequest;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIButton *labelButton;

@end

@implementation CommentsViewController

- (instancetype)initWithPullRequest:(PullRequest *)pullRequest {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    if (self) {
        _pullRequest = pullRequest;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _pullRequest.title;
    
    // Initialize fetch request controller
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comment"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pullRequest.pullRequestID = %@", _pullRequest.pullRequestID];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch: %@", error.localizedDescription);
    }
    
    // Observe updates (to catch updated from background)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    // Update pull requests objects
    [Comment getCommentsForPullRequest:_pullRequest completion:nil];
    [Label getLabelsForPullRequest:_pullRequest completion:nil];
    
    // Setup UI for table view
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 56;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    
    // Setup add/remove label functionality
    [self updateLabelsWithPullRequest:_pullRequest];
    
}

#pragma mark - UITableView DataSource & Delegate -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupComment:comment];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsController Delegate -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            CommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setupComment:anObject];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Actions -

- (IBAction)actionAddComment:(id)sender {
    if ([SessionManager sharedManager].isConnectionAvailable == NO) {
        NSString *title = @"You cannot post new comment because you are not connected to the Internet. Verify your data connection and try again later";
        [self showConnectionAlertWithTitle:title];
        return;
    }
    
    NewCommentViewController *viewController = [[NewCommentViewController alloc] initWithPullRequest:_pullRequest];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionLabel:(id)sender {
    if ([SessionManager sharedManager].isConnectionAvailable == NO) {
        NSString *title = @"You cannot change labels because you are not connected to the Internet. Verify your data connection and try again later";
        [self showConnectionAlertWithTitle:title];
        return;
    }
    
    if (![Label isLabelAvailable])
        return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:_pullRequest.label ? @"Delete Label" : @"Add +1 Label" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (_pullRequest.label)
            [Label deleteLabelForPullRequest:_pullRequest completion:nil];
        else
            [Label postLabelForPullRequest:_pullRequest completion:nil];
    }];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Others -

- (void)contextDidSave:(NSNotification *)notification {
    // Udpdate data and table UI in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Merge changes into main context
        [[NSManagedObjectContext MR_defaultContext] mergeChangesFromContextDidSaveNotification:notification];
        
        // Update fetched result controller and table view
        [NSFetchedResultsController deleteCacheWithName:nil];
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"Unable to perform fetch: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
        
        [self updateLabelsWithPullRequest:_pullRequest];
    });
}

- (void)updateLabelsWithPullRequest:(PullRequest *)pullRequest {
    self.labelButton.enabled = [Label isLabelAvailable];
    
    NSString *title;
    if (_pullRequest.label != nil)
        title = [NSString stringWithFormat:@"Labels: %@", _pullRequest.label.name];
    else
        title = @"No labels";

    if ([self.labelButton.titleLabel.text isEqualToString:title])
        return;
    
    [self.labelButton setTitle:title forState:UIControlStateNormal];
}

- (void)showConnectionAlertWithTitle:(NSString *)title {
    if (title.length == 0)
        title = @"You cannot perform this action because you are not connected to the Internet. Verify your data connection and try again later";
        
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Connection" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
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
