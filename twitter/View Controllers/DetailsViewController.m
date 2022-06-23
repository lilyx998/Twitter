//
//  DetailsViewController.m
//  twitter
//
//  Created by Lily Yang on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel; 
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *URLString = self.tweet.user.profilePicture;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileImageView setImageWithURL:url];
    
    self.nameLabel.text = self.tweet.user.name;
    self.tagLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    
    [self refreshLikeAndRetweet];
    
    self.timeAndDateLabel.text = self.tweet.dateAndTime;
}

- (void) refreshLikeAndRetweet{
    self.likeCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    
    if(self.tweet.favorited)
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    else
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    
    
    if(self.tweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
}

- (IBAction)didTapRetweet:(id)sender {
    if(!self.tweet.retweeted){
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error retweeting tweet: %@", error.localizedDescription);
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self refreshLikeAndRetweet];
                NSLog(@"❤️ Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error unretweeting tweet: %@", error.localizedDescription);
            else{
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self refreshLikeAndRetweet];
                NSLog(@"❤️ Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self.delegate.tableView reloadData];
}

- (IBAction)didTapLike:(id)sender {
    if(self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error unfavoriting tweet: %@", error.localizedDescription);
            else{
                NSLog(@"❤️ Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self refreshLikeAndRetweet];
            }
        }];
    }
    else{
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error favoriting tweet: %@", error.localizedDescription);
            else{
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self refreshLikeAndRetweet];
                NSLog(@"❤️ Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self.delegate.tableView reloadData];
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
