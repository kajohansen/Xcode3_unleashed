//
//  libRegressionSums.h
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#ifndef myLinear_libRegressionSums_h
#define myLinear_libRegressionSums_h

typedef struct Sums {
	unsigned	count;
	double		sumX;
	double		sumY;
	double		sumXSquared;
	double		sumYSquared;
	double		sumXY;
	int			dirty;
	double		slope;
	double		intercept;
	double		correlation;
} Sums, *SumsPtr;

#endif
