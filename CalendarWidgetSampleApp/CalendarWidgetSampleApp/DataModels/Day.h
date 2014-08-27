//
//  Day.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (strong, nonatomic) NSArray *timeslots;
@property (strong, nonatomic) NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end