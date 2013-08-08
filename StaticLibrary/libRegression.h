//
//  libRegression.h
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#ifndef myLinear_libRegression_h
#define myLinear_libRegression_h

void *RGCreate(void);

void RGAddPoint(void *aRegression, double inX, double inY);
void RGDeletePoint(void *aRegression, double inX, double inY);

unsigned RGCount(void *aRegression);

double RGMeanX(void *aResgression);
double RGMeanY(void *aRegression);

double RGSlope(void *aRegression);
double RGIntercept(void *aRegression);
double RGCorrelation(void *aRegression);

#endif
