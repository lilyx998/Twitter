//
//  User.h
//  twitter
//
//  Created by Lily Yang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;

-(instancetype) initWithDictionary: (NSDictionary *) dict; 

@end

NS_ASSUME_NONNULL_END
