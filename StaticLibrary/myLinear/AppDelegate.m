//
//  AppDelegate.m
//  myLinear
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#import "AppDelegate.h"
#import "libRegression.h"

@implementation AppDelegate

@synthesize slopeField, interceptField, correlationField, computeButton;
@synthesize dataPoints;

- (id) init {
    self = [super init];
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)computeWithLibrary:(id)sender {
    if ([[dataPoints arrangedObjects] count] > 1) {
        
        void *reg = RGCreate();
        
        // For each DataPoint...
        NSEnumerator *iter = [[dataPoints arrangedObjects] objectEnumerator];
        
        DataPoints *curr;
        while (curr = [iter nextObject]) {
            RGAddPoint(reg, [curr.x doubleValue], [curr.y doubleValue]);
        }
        
        if (RGCount(reg) > 1) {
            [slopeField setStringValue:[NSString stringWithFormat:@"%f", RGSlope(reg)]];
            [interceptField setStringValue:[NSString stringWithFormat:@"%f", RGIntercept(reg)]];
            [correlationField setStringValue:[NSString stringWithFormat:@"%f", RGCorrelation(reg)]];
        }
    }
}

#pragma mark - Property Lists

- (IBAction)loadPlist:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    if ([openPanel respondsToSelector:@selector(setAllowedFileTypes:)]) {
        [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];
    }
    
    void (^openPlist)(NSInteger) = ^( NSInteger resultCode )
	{
		if( resultCode == 1 )
		{
            NSMutableArray *pList2 = [[NSMutableArray alloc] initWithContentsOfURL:[openPanel URL]];
            for (DataPoints *point in pList2) {
                NSNumber *x = [point valueForKey:@"abscissa"];
                NSNumber *y = [point valueForKey:@"ordinate"];
                
                DataPoints *dPoint = [[DataPoints alloc] initWithX:[x doubleValue] Y:[y doubleValue]];
                [dataPoints addObject:dPoint];
            }
		} else {
            return;
        }
	};
    
    [openPanel beginSheetModalForWindow:self.window completionHandler:openPlist];
}

- (IBAction)saveAsPList:(id)sender {

    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    if ([savePanel respondsToSelector:@selector(setAllowedFileTypes:)]) {
        [savePanel setAllowedFileTypes: [NSArray arrayWithObject: @"plist"]];
    }
    
    void (^savePlist)(NSInteger) = ^( NSInteger resultCode )
	{
		if( resultCode == 1 )
		{
            NSMutableArray *pList2 = [[NSMutableArray alloc] init];
            for (DataPoints *point in [dataPoints arrangedObjects]) {
                [pList2 addObject:[point asPropertyList]];
            }
            [pList2 writeToURL:[savePanel URL] atomically:YES];
		} else {
            return;
        }
	};

    [savePanel beginSheetModalForWindow:self.window completionHandler:savePlist];
}


@end
