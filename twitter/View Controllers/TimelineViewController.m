//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "TweetCell.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController ()<ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) Tweet* replyToTweet;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    self.tableView.dataSource = self;

    // Get timeline
    [self getTimeline]; 
}

- (void) getTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.arrayOfTweets = (NSMutableArray *) tweets;

            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void) getMoreTimeline{
    Tweet* lastTweet = self.arrayOfTweets[self.arrayOfTweets.count-1];
    [[APIManager shared] getMoreHomeTimelineWithCompletion:(lastTweet.idStr)
                                            completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"🅿️🅿️🅿️ Successfully loaded MORE home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            [self.arrayOfTweets removeLastObject];
            [self.arrayOfTweets addObjectsFromArray: tweets];

            [self.tableView reloadData];
        } else {
            NSLog(@"🤬🤬🤬 Error getting MORE home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.arrayOfTweets = (NSMutableArray *) tweets;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogout:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Compose Segue"]){
        NSLog(@"Compose ✏️");
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.reply = NO;
    }
    else if([[segue identifier] isEqualToString:@"Reply Segue"]){ // to make API call, we need text and id-replying-to
        NSLog(@"Reply 🫦");
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.reply = YES;
        
        composeController.replyingToID = self.replyToTweet.idStr;
        composeController.replyingToMention = self.replyToTweet.user.screenName;
    }
    else{
        NSLog(@"Going into details view 🧐");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Tweet *tweetToPass = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.tweet = tweetToPass;
        detailsController.delegate = self; 
    }
}


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.arrayOfTweets.count-1){
        // ADD MORE FOR ENDLESS SCROLL
        [self getMoreTimeline];
        [self.tableView reloadData]; 
    }
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    cell.tweet = tweet;
    cell.delegate = self;
    [cell refreshCell];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)replyToTweet:(nonnull Tweet *)tweet {
    self.replyToTweet = tweet;
}

@end
