//
//  main.c
//  linrg
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#include <stdio.h>
#include <math.h>

int main(int argc, const char * argv[])
{
    int		nScanned;
	int		n;
	double	sumX;
    double  sumY;
	double	sumX2;
    double  sumY2;
	double	sumXY;
	
	n = 0;
	sumXY = 0.0;
    sumX = 0.0;
    sumY = 0.0;
    sumX2 = 0.0;
    sumY2 = 0.0;
	
	do {
		double x;
        double y;
		nScanned = scanf("%lg %lg", &x, &y);
		if (nScanned == 2) {
			n++;
			sumX += x;
			sumX2 += x * x;
			sumY += y;
			sumY2 += y * y;
			sumXY += x * y;
		}
	} while (nScanned == 2);
		
    double slope, intercept;
    slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    intercept = (sumY - slope * sumX) / n;
    double correlation = slope * sqrt((n * sumX2 - sumX * sumX) / (n * sumY2 - sumY * sumY));
    
    printf("%g\t%g\t%g\n", slope, intercept, correlation);
	
    return 0;
}

