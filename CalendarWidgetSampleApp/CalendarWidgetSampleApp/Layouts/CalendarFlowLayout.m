//
//  CalendarFlowLayout.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/18/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "CalendarFlowLayout.h"

@implementation CalendarFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 1;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end