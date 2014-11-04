//
//  Comment.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (instancetype) initWithDictionary:(NSDictionary *)commentDetail
{
    self = [super init];

    self.memberName = commentDetail [@"member_name"];
    self.memberID = commentDetail [@"member_id"];

    return self;
    
}

@end
