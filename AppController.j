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
var SegmentedButtonToolbarItemIdentifer = "SegmentedButtonToolbarItemIdentifier"

@implementation AppController : CPObject
{
    double bandgap;
    var fillView;
    var barChartCell;
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

- (IBAction) adjustSelectedPVCell: (id) sender
{
 
    var clickedSegment = [sender selectedSegment];
    if (clickedSegment == 0)
    {
        //SQ cell
        CPLogConsole(@"SQ PV selected");
        [barChartCell setShouldDisplaySQCell:YES];
        [barChartCell setShouldDisplayHCCell:NO];
        [barChartCell setNeedsDisplay:YES];
    }
    else if (clickedSegment == 1)
    {
        //HC Cell
        CPLogConsole(@"HC PV selected");
        [barChartCell setShouldDisplaySQCell:NO];
        [barChartCell setShouldDisplayHCCell:YES];
        [barChartCell setNeedsDisplay:YES];
    }
    else
    {
        //Error
    }
}
- (void) adjustBandgap: (id) sender
{
    //CPLogRegister(CPLogPopup);
    // Use y = mx + c to convert between slider bandgap and fractional position
    var m = 1.0/([sender maxValue] - [sender minValue]);
    var c = -[sender maxValue]/([sender maxValue] - [sender minValue]) + 1
    var fractionalPosition = m*[sender doubleValue] + c;
    //CPLogConsole(@"adjustBandgap: %@", fractionalPosition);
    [fillView setXFillFraction:fractionalPosition];
    [fillView setNeedsDisplay:YES];
    
    //When the bandgap changes we also need to update the cell efficiencies
    
    [barChartCell setCurrentSQCell:[self SQCellCurrent]];
    [barChartCell setEfficiencySQCell:[self SQCellEfficiency]];
    [barChartCell setVoltageSQCell:[self SQCellVoltage]];
    [barChartCell setCurrentHCCell:[self HCCellCurrent]];
    [barChartCell setEfficiencyHCCell:[self HCCellEfficiency]];
    [barChartCell setVoltageHCCell:[self HCCellVoltage]];
    [barChartCell setNeedsDisplay:YES];
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
    barChartCell = [[CellBarChartView alloc] initWithFrame:CPMakeRect(510, 100, 400, 300)];
    [barChartCell setVoltageSQCell:2.0];
    [barChartCell setCurrentSQCell:200.0];
    [barChartCell setEfficiencySQCell:0.5];
    [barChartCell setVoltageHCCell:2.5];
    [barChartCell setCurrentHCCell:500.0];
    [barChartCell setEfficiencyHCCell:0.7];
    //[barChartCell setAutoresizingMask:CPViewHeightSizable];

    
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

// ^^^^^^^^^^^^^^ Toolbar delegate code ^^^^^^^^^^^^^^

// Return an array of toolbar item identifier (all the toolbar items that may be present in the toolbar)
- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
   return [self toolbarDefaultItemIdentifiers:aToolbar];
}

// Return an array of toolbar item identifier (the default toolbar items that are present in the toolbar)
- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   //return [PopupLabelToolbarItemIdentifier, PopupToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier, SegmentedButtonToolbarItemIdentifer];
   return [SegmentedButtonToolbarItemIdentifer,CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier];
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
    else if (anItemIdentifier == SegmentedButtonToolbarItemIdentifer)
    {
        // Add a label to see the slider value changes
        var button = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        [button setSegmentCount:2];
        //[[button cell] setTrackingMode:CPSegmentedSwitchTrackingSelectAny];
        [button setLabel:@"Shockley–Queisser" forSegment:0];        
        [button setLabel:@"Hot–Carrier" forSegment:1];
        [button setWidth:60. forSegment:0];
        [button setWidth:60. forSegment:1];
        [button setSelectedSegment:0];
        [button setTarget:self];
        [button setAction:@selector(adjustSelectedPVCell:)];
        [toolbarItem setView:button];
        [toolbarItem setLabel:@"Cell type"];
        [toolbarItem setMinSize:CGSizeMake(268.,25)];
    }
    
    return toolbarItem;
}



// Paramaterised efficiency and voltage for the SQ and HC cells, with which we can find the voltage.

- (double) HCCellEfficiency
{
    var a  = 0.00130989;
    var b  = 1.41102;  
    var c  = -1.26123;  
    var d  = 0.437854;  
    var e  = -0.0692429;
    var f  = 0.00417117;
    var x  = [slider doubleValue];
    return a + b*x + c*x^2 + d*x^3 + e*x^4 + f*x^5;
}


- (double) HCCellVoltage
{
    var a = 0.101827;
    var b = 1.17471;
    var c = -0.941615;
    var d = 0.428836;
    var e = -0.109426;
    var f = 0.0145421;
    var g = -0.000782343;
    var x  = [slider doubleValue];
    return a + b*x + c*x^2 + d*x^3 + e*x^4 + f*x^5 + g*x^6;
}

- (double) HCCellCurrent
{
    return 1351.019*[self HCCellEfficiency]/[self HCCellVoltage];
}

- (double) SQCellEfficiency
{
    var a  = -0.00401806;
    var b  = -0.0974627; 
    var c  = 1.4996;     
    var d  = -1.89511;   
    var e  = 1.04876;    
    var f  = -0.304887;  
    var g  = 0.0456523;  
    var h  = -0.00278044;
    var x  = [slider doubleValue];
    return a + b*x + c*x^2 + d*x^3 + e*x^4 + f*x^5 + g*x^6 + h*x^7;
}

- (double) SQCellVoltage
{
    var a  = -0.0659911;
    var b  = 0.544191;  
    var c  = 0.267502;  
    var d  = -0.077008; 
    var e  = 0.00786633;
    var x  = [slider doubleValue];
    return a + b*x + c*x^2 + d*x^3 + e*x^4;
}

- (double) SQCellCurrent
{
    return 1351.019*[self SQCellEfficiency]/[self SQCellVoltage];
}

@end


