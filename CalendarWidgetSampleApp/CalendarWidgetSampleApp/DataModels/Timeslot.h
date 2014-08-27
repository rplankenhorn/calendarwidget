//
//  Timeslot.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeslot : NSObject

@property (copy, nonatomic) NSString *displayTitle;
@property (strong, nonatomic) NSDate *endTime;
@property (assign, nonatomic) NSTimeInterval endTimeMs;
@property (copy, nonatomic) NSString *eventPublicId;
@property (copy, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSTimeInterval startTimeMs;
@property (copy, nonatomic) NSString *timezone;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end