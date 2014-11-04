//
//  Comment.h
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong, nonatomic) NSNumber *memberID;
@property (strong, nonatomic) NSString *memberName;

- (instancetype) initWithDictionary:(NSDictionary *)commentDetail;

@end
