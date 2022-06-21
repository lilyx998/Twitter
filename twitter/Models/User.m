//
//  User.m
//  twitter
//
//  Created by Lily Yang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        self.name = dict[@"name"];
        self.screenName = dict[@"screen_name"];
        self.profilePicture = dict[@"profile_image_url_https"];
    }
    return self; 
}

@end
