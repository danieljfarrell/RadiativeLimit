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

- (void) adjustBandgapSlider: (double) newBandgap
{
    //CPLogConsole(@"adjustBandgapSlider ", newBandgap);
    //CGRect bounds = [fillView bounds];
    //double fractionalPosition = ([slider maxValue] - [slider minValue])/([slider maxValue] + [slider minValue]);
    //double newXOrigin = fractionalPosition * CGRectGetWidth(bounds);
    //double newWidth   = CPRectGetWidth(bounds) - newXOrigin;
    //CGRect newFilledRect = CPMakeRect(newXOrigin, 0.0, newWidth, CPRectGetHeight(bounds));
    //[fillView setFilledRect: newFilledRect];
    [fillView setFilledRect:CPMakeRect([slider value]*2, 0.0, 400, 400)];
    [fillView setNeedsDisplay:YES];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];
    
    //var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    //[label setStringValue:@"Hello World!"];
    //[label setFont:[CPFont boldSystemFontOfSize:24.0]];
    //[label sizeToFit];
    //[label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    //[label setCenter:[contentView center]];
    //[contentView addSubview:label];
    
    //The image view
    var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(10.0,60,500.,500.)];
    var background = [[CPImage alloc] initWithContentsOfFile:@"/Users/daniel/Desktop/spectrum.png"];
    [imageView setImage:background];
    //[imageView setHasShadow:YES];
    
    
    //The fill view
    //fillView = [[CPView alloc] initWithFrame:CPMakeRect(10.0,10.0,500.0,500.0)];
    //[fillView setBackgroundColor:[CPColor redColor]];
    fillView = [[FillView alloc] initWithFrame:CPMakeRect(10.0,60,500.0,500.0)];
    
    
    // The slider
    //var bandgapSlider = [[CPSlider alloc] initWithFrame:CPMakeRect(30.0, 520.0, 470, 50.0)];
    //[bandgapSlider setMinValue:0];
    //[bandgapSlider setMaxValue:5.0];
    //[bandgapSlider setDoubleValue: 3.0];

    //slider = [[BandgapSlider alloc] initWithFrame:CPMakeRect(30.0, 600, 470, 50.0)];
    slider = [[BandgapSlider alloc] initWithFrame:CPMakeRect(10., 10., 500, 50.0)];
    [slider setTarget:self];
    
    
    
    [contentView addSubview:fillView];
    [contentView addSubview:imageView];
    [contentView addSubview:slider];
    [theWindow orderFront:self];
    
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end


