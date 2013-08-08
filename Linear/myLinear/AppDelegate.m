//
//  AppDelegate.m
//  myLinear
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize slopeField, interceptField, correlationField, computeButton;
@synthesize dataPointsArray, linrgTask, slope, intercept, correlation, dataPoints;

- (id) init {

    self = [super init];
	dataPointsArray = [[NSMutableArray alloc] init];
	if (!dataPointsArray) {
		self = nil;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    [computeButton setEnabled:NO];
}

- (IBAction)computeWithLinrg:(id)sender {
    if (! [self canCompute]) {
		// Regression not possible; zero out and give up.
		slope = intercept = correlation = [[NSNumber alloc] initWithDouble:0.0];
		return;
	}
    	
	// With the Linrg tool...
	NSBundle *myBundle = [NSBundle mainBundle];
	NSString *linrgPath = [myBundle pathForResource: @"linrg" ofType: @""];
	linrgTask = [[NSTask alloc] init];
	[linrgTask setLaunchPath: linrgPath];
	
	// hook into stdin...
	NSPipe *inputPipe = [[NSPipe alloc] init];
	NSFileHandle *inputForData = [inputPipe fileHandleForWriting];
	[linrgTask setStandardInput:inputPipe];
	
	// hook into stdout...
	NSPipe *outputPipe = [[NSPipe alloc] init];
	NSFileHandle *outputForResults = [outputPipe fileHandleForReading];
	[linrgTask setStandardOutput:outputPipe];
	
	// await output in the dataRead: method...
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRead:) name:NSFileHandleReadToEndOfFileCompletionNotification object:outputForResults];
	[outputForResults readToEndOfFileInBackgroundAndNotify];
	
	// now run Linrg.
	[linrgTask launch];
	
	// For each DataPoint...
	NSEnumerator *iter = [[dataPoints arrangedObjects] objectEnumerator];
	
    DataPoints *curr;
	while (curr = [iter nextObject]) {
        
		// format point as string...
		NSString *currAsString = [NSString stringWithFormat: @"%@ %@\n", [curr x], [curr y]];
		// reduce string to ASCII data...
		NSData *currAsData = [currAsString dataUsingEncoding:NSASCIIStringEncoding];
		
        // put data into stdin...
		[inputForData writeData:currAsData];
	}
	
	// terminate stdin.
	[inputForData closeFile];
}

- (BOOL)canCompute {    
    return [[dataPoints arrangedObjects] count] > 1;
}

- (void)dataRead:(NSNotification *)aNotice { // When data arrives on stdout...
    
	NSDictionary *info = [aNotice userInfo];
	NSData *theData = [info objectForKey: NSFileHandleNotificationDataItem];
	
	// convert the data to a string...
	NSString *stringResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
	NSScanner *scanner = [NSScanner scannerWithString:stringResult];
	double	scratch;
	
	// and step through, collecting slope...
	[scanner scanDouble: &scratch];
    slope = [NSNumber numberWithDouble:scratch];
    [slopeField setStringValue:[NSString stringWithFormat:@"%@", slope]];
	
	// intercept...
	[scanner scanDouble: &scratch];
    intercept = [NSNumber numberWithDouble:scratch];
    [interceptField setStringValue:[NSString stringWithFormat:@"%@", intercept]];
	
	// and correlation.
	[scanner scanDouble: &scratch];
    correlation = [NSNumber numberWithDouble:scratch];
    [correlationField setStringValue:[NSString stringWithFormat:@"%@", correlation]];
	
	// Done with Linrg.
	linrgTask = nil;
}

#pragma mark Saving Property Lists

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
