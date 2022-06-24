//
//  TweetCell.h
//  twitter
//
//  Created by Lily Yang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TimelineViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate 

- (void) didSomething;

@end



@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *authorTagAndDate;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
//@property (weak, nonatomic) IBOutlet UIButton *replyButton; // TODO

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) TimelineViewController *timelineViewController;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void) refreshCell; 

@end

NS_ASSUME_NONNULL_END
