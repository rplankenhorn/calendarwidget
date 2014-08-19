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

- (void)drawRect:(CGRect)rect {
    if (self.booked) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, CGRectGetMaxY(rect));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), 0);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:197.0f/255.0f green:198.0f/255.0f blue:195.0f/255.0f alpha:1.0f].CGColor);
        CGContextStrokePath(ctx);
        CGPathRelease(path);
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    if (enabled) {
        self.dayLabel.textColor = [UIColor colorWithRed:87.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    } else {
        self.dayLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    }
}

- (void)setBooked:(BOOL)booked {
    _booked = booked;
    [self setNeedsDisplay];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:129.0f/255.0f green:140.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        [self setEnabled:self.enabled];
    }
}

- (void)setDayLabelText:(NSString *)dayString {
    self.dayLabel.text = dayString;
}

@end