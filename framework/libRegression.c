//
//  libRegression.c
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "libRegression.h"
#include "libRegressionSums.h"

void *RGCreate(void) {
	SumsPtr	retval = calloc(1, sizeof(Sums));
	return retval;
}

void RGAddPoint(void *aRegression, double inX, double inY) {
	SumsPtr	reg = (SumsPtr) aRegression;
	reg->count++;
	reg->sumX += inX;
	reg->sumY += inY;
	reg->sumXSquared += inX * inX;
	reg->sumYSquared += inY * inY;
	reg->sumXY += inX * inY;
	
	reg->dirty = 1;
}

void RGDeletePoint(void *aRegression, double inX, double inY) {
	SumsPtr	reg = (SumsPtr) aRegression;
	assert(reg->count > 0);
	
	reg->count--;
	reg->sumX -= inX;
	reg->sumY -= inY;
	reg->sumXSquared -= inX * inX;
	reg->sumYSquared -= inY * inY;
	reg->sumXY -= inX * inY;
	
	reg->dirty = 1;
}

static void	CalculateRegression(SumsPtr aRegression) {
	if (!aRegression->dirty || aRegression->count < 2)
		return;
	
	aRegression->slope = (aRegression->count * aRegression->sumXY - aRegression->sumX * aRegression->sumY)
                         /
                         (aRegression->count * aRegression->sumXSquared - aRegression->sumX * aRegression->sumX);
	
	aRegression->intercept = (aRegression->sumY - aRegression->slope * aRegression->sumX)
                             /
                             aRegression->count;
	
	aRegression->correlation = aRegression->slope * sqrt(
                              (aRegression->count * aRegression->sumXSquared - aRegression->sumX * aRegression->sumX)
                              /
                              (aRegression->count * aRegression->sumYSquared - aRegression->sumY * aRegression->sumY)
                              );
	aRegression->dirty = 0;
}

unsigned RGCount(void *aRegression) {
    return ((SumsPtr)aRegression)->count;
}

double RGSlope(void *aRegression) {
	CalculateRegression(((SumsPtr)aRegression));
	return ((SumsPtr)aRegression)->slope;
}

double RGIntercept(void *aRegression) {
	CalculateRegression(((SumsPtr)aRegression));
	return ((SumsPtr)aRegression)->intercept;
}

double RGCorrelation(void *aRegression) {
	CalculateRegression(((SumsPtr)aRegression));
	return ((SumsPtr)aRegression)->correlation;
}



