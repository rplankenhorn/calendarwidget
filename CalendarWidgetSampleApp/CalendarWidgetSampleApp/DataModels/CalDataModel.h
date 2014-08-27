//
//  CalDataModel.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"
#import "Timeslot.h"

@interface CalDataModel : NSObject

@property (strong, nonatomic) NSArray *days;

- (id)initWithFilePath:(NSString *)filePath;

@end