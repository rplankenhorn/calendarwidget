//
//  DatePickerCollectionViewCell.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "DatePickerCollectionViewCell.h"
#import "UIColor+Common.h"
#import <QuartzCore/QuartzCore.h>

@interface DatePickerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) CAShapeLayer *slashLayer;
@end

@implementation DatePickerCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.enabled = NO;
    self.booked = NO;
    self.isSelected = NO;
    [self.slashLayer removeFromSuperlayer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.booked) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0)];
        self.slashLayer = [CAShapeLayer layer];
        self.slashLayer.path = [path CGPath];
        self.slashLayer.strokeColor = [[UIColor dateSlashColor] CGColor];
        self.slashLayer.lineWidth = 2.0;
        self.slashLayer.fillColor = [[UIColor clearColor] CGColor];
        [self.layer addSublayer:self.slashLayer];
    } else {
        [self.slashLayer removeFromSuperlayer];
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    if (enabled) {
        self.dayLabel.textColor = [UIColor dateEnabledColor];
    } else {
        self.dayLabel.textColor = [UIColor dateDisabledColor];
    }
}

- (void)setBooked:(BOOL)booked {
    _booked = booked;
    
    if (booked) {
        self.dayLabel.textColor = [UIColor dateEnabledColor];
    } else {
        self.dayLabel.textColor = [UIColor dateDisabledColor];
    }
    
    [self setNeedsDisplay];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        self.contentView.backgroundColor = [UIColor dateSelectedBackgroundColor];
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor dateDeselectedBackgroundColor];
        [self setEnabled:self.enabled];
    }
}

- (void)setDayLabelText:(NSString *)dayString {
    self.dayLabel.text = dayString;
}

@end