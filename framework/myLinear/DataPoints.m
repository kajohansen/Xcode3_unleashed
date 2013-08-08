//
//  DataPoints.m
//  myLinear
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#import "DataPoints.h"

@implementation DataPoints

@synthesize x, y;

- (id) init {
    self = [super init];
	return [self initWithX: 0.0 Y: 0.0];
}

- (id)initWithX:(double)xValue Y:(double)yValue {
    self = [super init];
    
    NSNumber *initX = [[NSNumber alloc] initWithDouble:xValue];
    NSNumber *initY = [[NSNumber alloc] initWithDouble:yValue];
    
	self.x = initX;
	self.y = initY;
	
    return self;
}

- (void)toString {
    NSLog(@"X: %@ Y: %@", self.x, self.y);
}

- (NSDictionary *)asPropertyList {
    NSDictionary *dict = @{@"abscissa" : self.x, @"ordinate" : self.y};
	
    return dict; 
}

@end
