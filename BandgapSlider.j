@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation BandgapSlider : CPView
{
    var slider;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
        {
            slider = [[CPSlider alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(aFrame)/2.0 - 8, CGRectGetWidth(aFrame) - 15, 24)];

            [slider setMinValue:0.5];
            [slider setMaxValue:4.0];
            [slider setTarget:self];
            [slider setAction:@selector(sliderChangedValue:)];
            [self addSubview:slider];
            [slider setDoubleValue:2.0];
        }
    
    
    return self;
}

// This action is called when the slider is used by the user (sender is the slider that we have created in initWithFrame:)
- (void) sliderChangedValue:(id)sender
{
    CPLogConsole(@"moo");
	// This is the trick. 
	// We ask the application (CPApp) to trigger itself (nil) the action (adjustBandgap:) with 
	// the slider as the sender. This will allow us to call [sender value] to get the slider current value (as a double).
    [CPApp sendAction:@selector(adjustBandgap:) to:nil from:sender];
}


@end
