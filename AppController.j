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

//Some constants...
var SliderToolbarItemIdentifier = "SliderToolbarItemIdentifier";

@implementation AppController : CPObject
{
    double bandgap;
    var fillView;
    var slider;
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
    CPLogConsole(@"adjustBandgap: %@", [sender description]);
    var bounds = [fillView bounds];
    var fractionalPosition = [sender doubleValue]/([sender maxValue] - [sender minValue]);
    CPLogConsole([CPString stringWithFormat:@"fractional position %@", fractionalPosition]);
    var newXOrigin = fractionalPosition * CGRectGetWidth(bounds);
    var newWidth   = CPRectGetWidth(bounds) - newXOrigin;
    var newFilledRect = CPMakeRect(newXOrigin, 0.0, newWidth, CPRectGetHeight(bounds));
    [fillView setFilledRect: newFilledRect];
    //[fillView setFilledRect:CPMakeRect([slider doubleValue]*40, 0.0, 400, 400)];
    [fillView setNeedsDisplay:YES];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];
    
   	// Create the toolbar and set its delegate to be the AppController instance.
    var toolbar = [[CPToolbar alloc] initWithIdentifier:"Bandgap"];    
    [toolbar setDelegate:self];
	[toolbar setVisible:YES];
	// Associate the toolbar with the window
	[theWindow setToolbar:toolbar];
	
    
    //The image view
    var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(10.0,10.0,500.,500.)];
    var background = [[CPImage alloc] initWithContentsOfFile:@"Resources/spectrum.png"];
    [imageView setImage:background];
    
    //The fill view and slider
    fillView = [[FillView alloc] initWithFrame:CPMakeRect(10.0,10.0,500.0,500.0)];
    CPLogConsole([[toolbar items] description]);
    
    
    //slider = [[BandgapSlider alloc] initWithFrame:CPMakeRect(10., 10., 500, 50.0)];
    //[slider setTarget:self];
    
    [contentView addSubview:fillView];
    [contentView addSubview:imageView];
    //[contentView addSubview:slider];
    [theWindow orderFront:self];
    
    //[self adjustBandgapSlider:[slider doubleValue]];
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

// **************************** Toolbar delegate code ****************************

// Return an array of toolbar item identifier (all the toolbar items that may be present in the toolbar)
- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
   return [CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier];
}

// Return an array of toolbar item identifier (the default toolbar items that are present in the toolbar)
- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   return [CPToolbarFlexibleSpaceItemIdentifier, SliderToolbarItemIdentifier];
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
    
    return toolbarItem;
}

@end


