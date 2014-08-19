//
//  NSIndexPath+Utils.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/18/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "NSIndexPath+Utils.h"

@implementation NSIndexPath (Utils)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)indexPath {
    return (self.section == indexPath.section && self.row == indexPath.row);
}

@end