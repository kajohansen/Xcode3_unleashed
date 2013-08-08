//
//  PointStat.m
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "PointStat.h"
#import "LinearGraph.h"
#import <math.h>

@implementation PointStat

- (id) init {
    dirty = YES;
    return self;
}

- (void) refreshData {
    dirty = YES;
}

- (BOOL)collectStatistics {
    if (!delegate || !dirty) {
        return NO;
    }
    count = [[[delegate dataPoints] arrangedObjects] count];
    
    if (count <= 1) {
        return NO;
    }
        
    sumX = sumY = sumXSquared = sumYSquared = sumXY = 0.0;
    
    double x, y;
    unsigned index;
    
    for (index = 0; index < count; index++) {
        DataPoints *curr = [[[delegate dataPoints] arrangedObjects] objectAtIndex:index];
        x = [curr.x doubleValue];
        y = [curr.y doubleValue];
        sumX += x; sumXSquared += x * x;
        sumY += y;
        sumYSquared += y * y;
        sumXY += x * y;
    }
    sumSqFromMeanX = sumSqFromMeanY = 0.0;
    
    if (count > 0) {
        double meanX = sumX / count;
        double meanY = sumY / count;
        
        for (index = 0; index < count; index++) {
            DataPoints *curr = [[[delegate dataPoints] arrangedObjects] objectAtIndex:index];
            x = [curr.x doubleValue];
            y = [curr.y doubleValue];
            double term = x - meanX;
            sumSqFromMeanX += term * term;
            term = y - meanY;
            sumSqFromMeanY += term * term;
        }
    }
    if (count > 0) {
        slope = (count * sumXY - sumX * sumY) / (count * sumXSquared - sumX * sumX);
    }
    dirty = NO;
    return YES;
}

#pragma mark Accessors
- (double) meanX {
    [self collectStatistics];
    return sumX / count;
}
- (double) meanY {
    [self collectStatistics];
    return sumY / count;
}
- (double) stdDeviationX {
    [self collectStatistics];
    return sqrt(sumSqFromMeanX) / count;
}
- (double) stdDeviationY {
    [self collectStatistics];
    return sqrt(sumSqFromMeanY) / count;
}
- (BOOL) regressionValid {
    return delegate && [[[delegate dataPoints] arrangedObjects] count] > 1;
}
- (double) slope {
    [self collectStatistics];
    return slope;
}
- (double) intercept {
    [self collectStatistics];
    return (sumY -slope * sumX) / count;
}
- (double) correlation {
    [self collectStatistics];
    return slope * sqrt( (count * sumXSquared - sumX * sumX) / (count * sumYSquared - sumY * sumY) );
}

#pragma mark - Delegate
- (id) delegate {
    return delegate;
}
static BOOL NotImpl(id object, SEL aSelector) {
    // Helper for setDelegate:
    // Detects whether a proposed delegate fails to // implement a method. Allow nil also.
    return (object != nil) && ![object respondsToSelector: aSelector];
}

- (void)setDelegate:(id)newDelegate {
    if (delegate != newDelegate) {
        // Check for compliance with (most of) the
        // informal protocol.
        if (NotImpl(newDelegate, @selector(computeWithLibrary))) {
            NSString * reason = [NSString stringWithFormat:@"%@ doesn’t implement needed methods", newDelegate];
            NSException * exception = [NSException exceptionWithName: NSInvalidArgumentException reason: reason userInfo: nil];
            @throw exception;
        }
        // Record the new delegate.
        delegate = newDelegate;
    }
}

@end




