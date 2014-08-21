//
//  DatePickerCollectionViewCell.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "DatePickerCollectionViewCell.h"
#import "UIColor+Common.h"

@interface DatePickerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end

@implementation DatePickerCollectionViewCell

- (void)drawRect:(CGRect)rect {
    if (self.booked) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, CGRectGetMaxY(rect));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), 0);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextSetStrokeColorWithColor(ctx,[UIColor dateSlashColor].CGColor);
        CGContextStrokePath(ctx);
        CGPathRelease(path);
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