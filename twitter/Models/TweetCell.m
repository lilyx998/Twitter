//
//  TweetCell.m
//  twitter
//
//  Created by Lily Yang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshCell{
    self.tweetText.text = self.tweet.text;
    self.authorNameLabel.text = self.tweet.user.name;
    
    self.numberOfLikes.text = [@(self.tweet.favoriteCount) stringValue];
    self.numberOfRetweets.text = [@(self.tweet.retweetCount) stringValue];
    self.tweet = self.tweet;
    
    NSString *URLString = self.tweet.user.profilePicture;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileImage setImageWithURL:url];

    NSString *date = self.tweet.createdAtString;
    
    NSString *authorTagAndDateString = [[[@"@" stringByAppendingString:self.tweet.user.screenName] stringByAppendingString:@" - "] stringByAppendingString:self.tweet.createdAtString];
    self.authorTagAndDate.text = authorTagAndDateString;
    
    if(self.tweet.favorited)
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    else
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    
    
    if(self.tweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error unfavoriting tweet: %@", error.localizedDescription);
            else{
                NSLog(@"❤️ Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self refreshCell];
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
                [self refreshCell];
                NSLog(@"❤️ Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if(!self.tweet.retweeted){
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
                NSLog(@"💔 Error retweeting tweet: %@", error.localizedDescription);
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self refreshCell];
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
                [self refreshCell];
                NSLog(@"❤️ Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

@end
