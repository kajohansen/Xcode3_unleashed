//
//  LinearGraph.h
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataPoints.h"
#import "AppDelegate.h"
#import "libRegression.h"

@interface LinearGraph : NSView 

@property (nonatomic, strong)NSArray *dataPoints;
@property (nonatomic, strong)NSNumber *slope;
@property (nonatomic, strong)NSNumber *intercept;

- (void)refreshData;

@end
