//
//  DataPoints.h
//  myLinear
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPoints : NSObject

@property (nonatomic, strong)NSNumber *x;
@property (nonatomic, strong)NSNumber *y;

- (id)initWithX:(double)xValue Y:(double) yValue;

- (void)toString;

- (NSDictionary *)asPropertyList;

@end
