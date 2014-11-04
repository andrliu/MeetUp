//
//  Event.h
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSDictionary *group;
@property (strong, nonatomic) NSString *groupInfo;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *url;

- (instancetype) initWithDictionary:(NSDictionary *)eventDetail;

@end
