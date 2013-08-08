/*
 *  libRegression.cp
 *  libRegression
 *
 *  Created by Super User on 01.05.13.
 *  Copyright (c) 2013 KAjohansen. All rights reserved.
 *
 */

#include "libRegression.h"
#include "libRegressionPriv.h"

CFStringRef libRegressionUUID(void)
{
	ClibRegression* theObj = new ClibRegression;
	return theObj->UUID();
}

CFStringRef ClibRegression::UUID()
{
	return CFSTR("0001020304050607");
}

#ifndef Regression_libRegression_h
#define Regression_libRegression_h

void	*RGCreate(void);
//void	RGRelease(void *aRegression);

void	RGAddPoint(void *aRegression, double inX, double inY);
void	RGDeletePoint(void *aRegression, double inX, double inY);

unsigned	RGCount(void *aRegression);

double	RGMeanX(void *aResgression);
double	RGMeanY(void *aRegression);

double	RGSlope(void *aRegression);
double	RGIntercept(void *aRegression);
double	RGCorrelation(void *aRegression);

#endif
