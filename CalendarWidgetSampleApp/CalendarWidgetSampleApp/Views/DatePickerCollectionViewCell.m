//
//  DatePickerCollectionViewCell.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "DatePickerCollectionViewCell.h"

@interface DatePickerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end

@implementation DatePickerCollectionViewCell

- (void)setDayLabelText:(NSString *)dayString {
    self.dayLabel.text = dayString;
}

@end