//
//  CalDataModel.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/26/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "CalDataModel.h"

@interface CalDataModel ()
@property (copy, nonatomic) NSString *filePath;
@end

@implementation CalDataModel

- (id)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSError *error;
    NSInputStream *input = [[NSInputStream alloc] initWithFileAtPath:self.filePath];
    [input open];
    NSDictionary *jsonData = (NSDictionary *)[NSJSONSerialization JSONObjectWithStream:input options:0 error:&error];
    
    NSArray *daysArray = [[jsonData objectForKey:@"result"] objectForKey:@"days"];
    
    NSMutableArray *mutDays = [[NSMutableArray alloc] init];
    
    for (int i=0; i<daysArray.count; i++) {
        Day *d = [[Day alloc] initWithDictionary:daysArray[i]];
        [mutDays addObject:d];
    }
    
    self.days = [[NSArray alloc] initWithArray:mutDays];
}

@end