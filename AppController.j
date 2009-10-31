/*
 * AppController.j
 * TestProject
 *
 * Created by You on October 17, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/AppKit.j>
@import "FillView.j"
@import "BandgapSlider.j"
@import "CellBarChartView.j"

//Some constants...
var SliderToolbarItemIdentifier = "SliderToolbarItemIdentifier";
var PopupToolbarItemIdentifier = "PopupToolbarItemIdentifier";
var PopupLabelToolbarItemIdentifier = "PopupLabelToolbarItemIdentifier";

@implementation AppController : CPObject
{
    double bandgap;
    var fillView;
    var barChartSQCell;
    var slider;
    CPPopUpButton cellType;
}

- (double) bandgap
{
    return bandgap;
}

- (void) setBandgap: (double) newBandgap
{
    bandgap = newBandgap;
}

- (void) adjustBandgap: (id) sender
{
    CPLogRegister(CPLogPopup);
    // Use y = mx + c to convert between slider bandgap and fractional position
    var m = 1.0/([sender maxValue] - [sender minValue]);
    var c = -[sender maxValue]/([sender maxValue] - [sender minValue]) + 1
    var fractionalPosition = m*[sender doubleValue] + c;
    CPLogConsole(@"adjustBandgap: %@", fractionalPosition);
    [fillView setXFillFraction:fractionalPosition];
    [fillView setNeedsDisplay:YES];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];
    
   	// Create the toolbar and set its delegate to be the AppController instance.
    var toolbar = [[CPToolbar alloc] initWithIdentifier:"Toolbar"];    
    [toolbar setDelegate:self];
	[toolbar setVisible:YES];
	[theWindow setToolbar:toolbar];
	
    
    //The image view
    var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(10.0,10.0,500.,500.)];
    var background = [[CPImage alloc] initWithContentsOfFile:@"Resources/spectrum.png"];
    [imageView setImage:background];
    
    //The fill view and slider
    fillView = [[FillView alloc] initWithFrame:CPMakeRect(84,10.0,360.,500.0)];
    
    //Bar chart view for Shockley–Queisser cell
    barChartCell = [[CellBarChartView alloc] initWithFrame:CPMakeRect(510, 10, 400, 300)];
    [barChartCell setVoltageSQCell:2.0];
    [barChartCell setCurrentSQCell:200.0];
    [barChartCell setEfficiencySQCell:0.5];
    [barChartCell setVoltageHCCell:2.5];
    [barChartCell setCurrentHCCell:500.0];
    [barChartCell setEfficiencyHCCell:0.7];
    [barChartCell setAutoresizingMask:CPViewHeightSizable];

    
    [contentView addSubview:fillView];
    [contentView addSubview:imageView];
    [contentView addSubview:barChartCell];
    [theWindow orderFront:self];
    
    CPLogConsole([[slider slider] description]);
    CPLogConsole([slider description]);
    
    //Assign slider
    var i=0
    for (i=0;i<[[toolbar items] count];i=i+1)
        {
            
            if ([[[[toolbar items] objectAtIndex:i] itemIdentifier] isEqualToString:SliderToolbarItemIdentifier])
            {
                slider = [[[[toolbar items] objectAtIndex:i] view] slider];
            }
        }
    
    [self adjustBandgap:slider];
    [contentView setNeedsDisplay:YES];
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

// **************************** Toolbar delegate code ****************************

// Return an array of toolbar item identifier (all the toolbar items that may be present in the toolbar)
- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
   return [self toolbarDefaultItemIdentifiers:aToolbar];
}

// Return an array of toolbar item identifier (the default toolbar items that are present in the toolbar)
- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   return [PopupLabelToolbarItemIdentifier, PopupToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier];
}


- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag
{
	// Create the toolbar item and associate it with its identifier
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];

    if (anItemIdentifier == SliderToolbarItemIdentifier)
    {
    	// The toolbar is using a custom view (of class BandgapSlider)
        [toolbarItem setView:[[BandgapSlider alloc] initWithFrame:CGRectMake(0, 0, 180, 50)]];
        
        // We don't associate a target/action with the toolbar item. 
        // This will be done in the slider contained in the BandgapSlider.
        [toolbarItem setLabel:"Bandgap"];

        [toolbarItem setMinSize:CGSizeMake(180, 32)];
        [toolbarItem setMaxSize:CGSizeMake(180, 32)];
    }
    else if (anItemIdentifier == PopupToolbarItemIdentifier)
    {
        cellType = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 180, 24)];
        //cellType = [[CPPopUpButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(aFrame)/2.0 - 8, CGRectGetWidth(aFrame) - 15, 24)];
        //[cellType setAlignment:CPCenterTextAlignment];
        [cellType addItemWithTitle:@"Shockley–Queisser"];
        [cellType addItemWithTitle:@"Hot–Carrier"];
        //[cellType setPullsDown:YES];
        [toolbarItem setView:cellType];
        //[toolbarItem setLabel:@"Solar Cell Type"];
        [toolbarItem setMinSize:CGSizeMake(180,24)];
        [toolbarItem setMinSize:CGSizeMake(180,24)];

    }
    else if (anItemIdentifier == PopupLabelToolbarItemIdentifier)
    {
        // Add a label to see the slider value changes
        var label = [CPTextField labelWithTitle:@"Solar Cell Type:"];
        //[label setAlignment:CPCenterTextAlignment];
        [label setFont:[CPFont systemFontOfSize:12.0]];
        CPLogConsole([[CPFont systemFontOfSize:12.0] familyName]);
        //[label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
        //[label setFrameOrigin:CGPointMake((CGRectGetWidth([contentView bounds]) - CGRectGetWidth([label frame])) / 2.0, (CGRectGetHeight([contentView bounds]) - CGRectGetHeight([label frame])) / 2.0)];
        
        [toolbarItem setView:label];
        //[toolbarItem setLabel:@"Solar Cell Type:"];
        [toolbarItem setMinSize:CGSizeMake(90.,25)];

    }
    
    return toolbarItem;
}

@end


