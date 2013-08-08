//
//  PointStat.h
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointStat : NSObject {
    unsigned long count;
    double sumX;
    double sumY;
    double sumXY;
    double sumXSquared;
    double sumYSquared;
    double slope;
    double sumSqFromMeanX;
    double sumSqFromMeanY;
    BOOL dirty;
    id delegate;
}

- (id) init;
- (void) refreshData;
- (double) meanX;
- (double) meanY;
- (double) stdDeviationX;
- (double) stdDeviationY;
- (BOOL) regressionValid;
- (double) slope;
- (double) intercept;
- (double) correlation;
- (id) delegate;
- (void)setDelegate: (id)newDelegate;

@end
