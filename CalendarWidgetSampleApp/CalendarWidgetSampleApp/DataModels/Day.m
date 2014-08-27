//
//  Day.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "Day.h"
#import "Timeslot.h"

@interface Day ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation Day

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return _dateFormatter;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.date = [self.dateFormatter dateFromString:[dictionary objectForKey:@"date"]];
        NSMutableArray *mutTimeslots = [[NSMutableArray alloc] init];
        NSArray *timeslotDictionaries = [dictionary objectForKey:@"timeslots"];
        
        for (int i=0; i<timeslotDictionaries.count; i++) {
            Timeslot *t = [[Timeslot alloc] initWithDictionary:[timeslotDictionaries objectAtIndex:i]];
            [mutTimeslots addObject:t];
        }
        
        self.timeslots = [[NSArray alloc] initWithArray:mutTimeslots];
    }
    return self;
}

@end