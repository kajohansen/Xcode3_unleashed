//
//  LinearGraph.m
//  myLinear
//
//  Created by Super User on 01.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "LinearGraph.h"

@implementation LinearGraph

@synthesize dataPoints, slope, intercept;

static NSColor *sAxisColor = nil;
static NSColor *sPointColor = nil;
static NSColor *sLineColor = nil;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
        
        self.dataPoints = [[NSArray alloc] initWithArray:[delegate.dataPoints arrangedObjects]];
        self.slope = [NSNumber numberWithDouble:[delegate.currSlope doubleValue]];
        self.intercept = [NSNumber numberWithDouble:[delegate.currIntercept doubleValue]];
        
        sAxisColor = [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		sPointColor = [NSColor colorWithCalibratedRed:0.0 green:0.7 blue:0.0 alpha:1.0];
		sLineColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
		
    // What rect encloses all the points?
    NSRect dataBounds = [self dataExtent];
    
    // Lower-left corner of the all-points rect
    NSPoint	origin = dataBounds.origin;
    float	margin;
    
    // Horizontal margin
    margin = dataBounds.size.width * 0.05;
    dataBounds.origin.x -= margin;
    dataBounds.size.width += 2.0 * margin;
    
    // Vertical margin
    margin = dataBounds.size.height * 0.05;
    dataBounds.origin.y -= margin;
    dataBounds.size.height += 2.0 * margin;
    
    // Make my coordinates == point coordinates
    [self setBounds: dataBounds];
    
    NSSize unitSize = {1.0, 1.0};
    
    // Convert the window’s one-pixel size to this view’s coordinate dimensions.
    unitSize = [self convertSize: unitSize fromView: nil];
    [NSBezierPath setDefaultLineWidth: MIN(unitSize.height, unitSize.width)];
    
    // Draw axes from the original minimum of dataBounds:
    [sAxisColor set];
    
    // vertical
    [NSBezierPath strokeLineFromPoint: NSMakePoint(origin.x, NSMinY(dataBounds))
                              toPoint: NSMakePoint(origin.x, NSMaxY(dataBounds))];
    // horizontal
    [NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(dataBounds), origin.y)
                              toPoint: NSMakePoint(NSMaxX(dataBounds), origin.y)];
    
    // Use the line color
    [sLineColor set]; 
    
    // Y of regression line at the left.
    float y0 = [intercept doubleValue] + [slope doubleValue] * NSMinX(dataBounds);
    
    // Y of regression line at the right.
    float yN = [intercept doubleValue] + [slope doubleValue] * NSMaxX(dataBounds);
    
    // Draw the regression line across the view.
    [NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(dataBounds), y0) toPoint: NSMakePoint(NSMaxX(dataBounds), yN)];
    
    [[NSGraphicsContext currentContext] flushGraphics];
    
    // Draw points:
    [sPointColor set];	// Use the point color
    
    // For each DataPoint...
	NSEnumerator *iter = [dataPoints objectEnumerator];
	
    DataPoints *curr;
    while (curr = [iter nextObject]) {
        
        double x = [curr.x doubleValue];
        double y = [curr.y doubleValue];
        
        NSRect pointRect = NSMakeRect(x - 2.0 * unitSize.width,
                                      y - 2.0 * unitSize.height,
                                      4.0 * unitSize.width,
                                      4.0 * unitSize.height);
        
        // Fill the small rectangle with the point color.
        NSRectFill(pointRect);
        
        [[NSGraphicsContext currentContext] flushGraphics];
	}
}

- (NSRect) dataExtent {
    
    DataPoints *first = [dataPoints objectAtIndex:0];
        
	NSRect retval = NSMakeRect([first.x doubleValue], [first.y doubleValue], 0.0, 0.0);
	
    // For each DataPoint...
	NSEnumerator *iter = [dataPoints objectEnumerator];
	
    DataPoints *curr;
    while (curr = [iter nextObject]) {
        
        NSPoint	currPoint = NSMakePoint([curr.x doubleValue], [curr.y doubleValue]);
        
        if (!NSPointInRect(currPoint, retval)) {
			// If a point in the list is outside the known
			// limits, expand the limits to include it.
			
			if (currPoint.x < NSMinX(retval)) {
				retval.size.width += NSMinX(retval) -currPoint.x;
				retval.origin.x = currPoint.x;
			}
			
			if (currPoint.x > NSMaxX(retval))
				retval.size.width += currPoint.x -NSMaxX(retval);
            
			if (currPoint.y < NSMinY(retval)) {
				retval.size.height += NSMinY(retval)-currPoint.y;
				retval.origin.y = currPoint.y;
			}
			
			if (currPoint.y > NSMaxY(retval))
				retval.size.height += currPoint.y-NSMaxY(retval);
		}
	}
	return retval;
}

- (void)refreshData {
	// Force a redraw of the view, which means
	// a reload of the data.
	[self setNeedsDisplay: YES];
}


@end
