//
//  Timeslot.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "Timeslot.h"

@interface Timeslot ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation Timeslot

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    }
    return _dateFormatter;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.displayTitle = [dictionary objectForKey:@"displayTitle"];
        self.endTime = [self.dateFormatter dateFromString:[dictionary objectForKey:@"endTime"]];
        self.endTimeMs = [[dictionary objectForKey:@"endTimeMs"] doubleValue];
        self.eventPublicId = [dictionary objectForKey:@"eventPublicId"];
        self.eventType = [dictionary objectForKey:@"eventType"];
        self.startTime = [self.dateFormatter dateFromString:[dictionary objectForKey:@"startTime"]];
        self.startTimeMs = [[dictionary objectForKey:@"startTimeMs"] doubleValue];
        self.timezone = [dictionary objectForKey:@"timezone"];
    }
    return self;
}

@end