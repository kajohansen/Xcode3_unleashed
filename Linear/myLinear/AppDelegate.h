//
//  AppDelegate.h
//  myLinear
//
//  Created by Super User on 13.12.12.
//  Copyright (c) 2012 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataPoints.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSButton *computeButton;
@property (weak) IBOutlet NSFormCell *slopeField;
@property (weak) IBOutlet NSFormCell *interceptField;
@property (weak) IBOutlet NSFormCell *correlationField;
@property (weak) IBOutlet NSArrayController *dataPoints;

@property (nonatomic, strong)NSMutableArray *dataPointsArray;
@property (nonatomic, strong)NSTask *linrgTask;

@property (nonatomic, strong)NSNumber *slope;
@property (nonatomic, strong)NSNumber *intercept;
@property (nonatomic, strong)NSNumber *correlation;


- (BOOL)canCompute;
- (IBAction)computeWithLinrg:(id)sender;
- (IBAction)saveAsPList:(id)sender;
- (IBAction)loadPlist:(id)sender;
- (void)dataRead:(NSNotification *)aNotice;


@end
