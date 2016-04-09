//
//  PullRequestViewController.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/4/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "PullRequestViewController.h"
#import "PullRequestCell.h"
#import "PullRequest.h"
#import "CommentsViewController.h"
#import "AccountsViewController.h"

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@interface PullRequestViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, AccountsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation PullRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];

    // Initialize fetch request controller
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PullRequest"];
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
    
    // Update PullRequest objects
    [PullRequest getPullRequests:^(id result, NSError *error){
    }];
}

- (void)contextDidSave:(NSNotification *)notification {
    // Udpdate data and UI in main thread
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
    });
}

#pragma mark - UITableView DataSource & Delegate -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PullRequestCell";
    PullRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PullRequest *pullRequest = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupPullRequest:pullRequest];
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
    PullRequest *pullRequest = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CommentsViewController *commentsVC = [[CommentsViewController alloc] initWithPullRequest:pullRequest];
    [self.navigationController pushViewController:commentsVC animated:YES];
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
            PullRequestCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setupPullRequest:anObject];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

#pragma mark - Actions -

- (IBAction)actionAccounts:(id)sender {
    AccountsViewController *viewController = [[AccountsViewController alloc] init];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didChangeAccount:(AccountsViewController *)viewController {
    // Update PullRequest objects
    [PullRequest getPullRequests:nil];
}


#pragma mark - Others -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
