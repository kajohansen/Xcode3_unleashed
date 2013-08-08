//
//  PointCountTransformer.m
//  myLinear
//
//  Created by Super User on 30.04.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "PointCountTransformer.h"

@implementation PointCountTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {    
    return ([value integerValue] > 1) ? [NSNumber numberWithInt:1] : nil;
}

@end
