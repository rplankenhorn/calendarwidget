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

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self.collectionView registerNib:[UINib nibWithNibName:kPickerCollectionViewCellXib bundle:nil] forCellWithReuseIdentifier:kPickerCollectionViewCellIdentifier];
}

#pragma mark - Actions

- (void)refreshCalendar {
    if (self.selectedIndex != nil &&
        self.selectedIndex.row != INT_MAX &&
        self.selectedIndex.section != INT_MAX) {
        DatePickerCollectionViewCell *cell = [self retrieveDatePickerCellWithCollectionView:self.collectionView andIndexPath:self.selectedIndex];
        [cell setSelected:NO];
        self.selectedIndex = nil;
    }
    
    [self.collectionView reloadData];
}

- (void)clear {
    // Need to set selectedIndex to a value that isn't nil so that when we refresh the collection view, we don't
    // automatically select the current date.
    self.selectedIndex = [NSIndexPath indexPathForRow:INT_MAX inSection:INT_MAX];
    [self refreshCalendar];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(NO, @"collectionView:numberOfItemsInSection: must be overridden in the child class!");
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self retrieveDatePickerCellWithCollectionView:collectionView
                                             andIndexPath:indexPath];
}

- (DatePickerCollectionViewCell *)retrieveDatePickerCellWithCollectionView:(UICollectionView *)collectionView
                                                              andIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"retrieveDatePickerCellWithCollectionView:andIndexPath: must be overridden in the child class!");
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [self retrieveDatePickerCellWithCollectionView:collectionView andIndexPath:indexPath];
    if (cell.enabled &&
        !cell.booked) {
        self.selectedIndex = indexPath;
        [self.collectionView reloadData];
    }
}

@end