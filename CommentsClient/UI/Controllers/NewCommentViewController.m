//
//  NewCommentViewController.m
//  CommentsClient
//
//  Created by Stanislav Shpak on 4/6/16.
//  Copyright © 2016 Stanislav Shpak. All rights reserved.
//

#import "NewCommentViewController.h"
#import "Comment.h"

@interface NewCommentViewController () {
    PullRequest *_pullRequest;
}

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation NewCommentViewController

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
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.commentTextView becomeFirstResponder];
}

#pragma mark - Actions -

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionPost:(id)sender {
    if ([self validateInputText:self.commentTextView.text] == NO) {
        NSString *title = @"Comment cannot be empty. Please write comment text and try again.";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [Comment postComment:self.commentTextView.text forPullRequest:_pullRequest completion:^(id result, NSError *error) {
        if (!error) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (BOOL)validateInputText:(NSString *)text {
    return !(text.length == 0);
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
