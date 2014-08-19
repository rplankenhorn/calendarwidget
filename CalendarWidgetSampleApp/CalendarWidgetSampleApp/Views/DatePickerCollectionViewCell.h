//
//  DatePickerCollectionViewCell.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL booked;
@property (assign, nonatomic) BOOL isSelected;

- (void)setDayLabelText:(NSString *)dayString;

@end