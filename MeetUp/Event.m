//
//  Event.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype) initWithDictionary:(NSDictionary *)eventDetail
{
    self = [super init];

    self.name = eventDetail [@"name"];
    self.count = eventDetail [@"yes_rsvp_count"];
    self.group = eventDetail [@"group"];
    self.groupInfo = self.group[@"name"];
    self.eventDescription = eventDetail [@"description"];
    self.url = eventDetail [@"event_url"];

    return self;
    
}

@end
