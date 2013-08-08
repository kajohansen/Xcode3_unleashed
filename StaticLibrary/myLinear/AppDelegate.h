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

- (IBAction)computeWithLibrary:(id)sender;
- (IBAction)saveAsPList:(id)sender;
- (IBAction)loadPlist:(id)sender;


@end
