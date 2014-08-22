//
//  BasePickerView.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/21/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.calendarFlowLayout];
        _collectionView.backgroundColor = [UIColor colorWithRed:197.0f/255.0f green:198/255.0f  blue:195.0f/255.0f  alpha:1.0f];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _collectionView;
}

- (CalendarFlowLayout *)calendarFlowLayout {
    if (!_calendarFlowLayout) {
        _calendarFlowLayout = [[CalendarFlowLayout alloc] init];
        [_calendarFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _calendarFlowLayout.minimumInteritemSpacing = 0;
        _calendarFlowLayout.minimumLineSpacing = 0;
    }
    return _calendarFlowLayout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(NO, @"collectionView:numberOfItemsInSection: must be overridden in the child class!");
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"collectionView:cellForItemAtIndexPath: must be overridden in the child class!");
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSAssert(NO, @"numberOfSectionsInCollectionView: must be overridden in the child class!");
    return 0;
}

@end