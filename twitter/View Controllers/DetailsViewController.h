//
//  DetailsViewController.h
//  twitter
//
//  Created by Lily Yang on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TimelineViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface DetailsViewController : UIViewController

@property Tweet *tweet;
@property (nonatomic, weak) TimelineViewController *delegate;

@end

NS_ASSUME_NONNULL_END
