//
//  Tweet.m
//  twitter
//
//  Created by Lily Yang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

//@property (nonatomic, strong) NSString *idStr;                // For favoriting, retweeting & replying
//@property (nonatomic, strong) NSString *text;                 // Text content of tweet
//@property (nonatomic) int favoriteCount;                      // Update favorite count label
//@property (nonatomic) BOOL favorited;                         // Configure favorite button
//@property (nonatomic) int retweetCount;                       // Update favorite count label
//@property (nonatomic) BOOL retweeted;                         // Configure retweet button
//@property (nonatomic, strong) User *user;                     // Contains Tweet author's name, screenname, etc.
//@property (nonatomic, strong) NSString *createdAtString;      // Display date
//@property (nonatomic, strong) User *retweetedByUser;          // If the tweet is a retweet, this will be the user who retweeted


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];

        // initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];

        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.createdAtString = [formatter stringFromDate:date];
    }
    return self;
}

+ (NSMutableArray *) tweetsWithArray:(NSArray *) dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dict in dictionaries){
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dict];
        [tweets addObject:tweet];
    }
    return tweets; 
}

@end
