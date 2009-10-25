@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation BandgapSlider : CPView
{
    var slider;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    slider = [[CPSlider alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(aFrame)/2.0 - 8, CGRectGetWidth(aFrame) - 65, 24)];
    [slider setContinuous:YES];
    [slider setMinValue:0.0];
    [slider setMaxValue:5.0];
    [slider setDoubleValue:3.0];
    [slider setAction:@selector(adjustBandgapSlider:)];
    [self addSubview:slider];
            
    /*                                                 
    var label = [CPTextField labelWithText:@"0"];
    [label setFrameOrigin:CGPointMake(0, CGRectGetHeight(aFrame)/2.0 - 4.0)];
    [self addSubview:label];

    label = [CPTextField labelWithText:@"5"];
    [label setFrameOrigin:CGPointMake(CGRectGetWidth(aFrame) - CGRectGetWidth([label frame]), CGRectGetHeight(aFrame)/2.0 - 4.0)];
    [self addSubview:label];
    */
    return self;
}


- (void) setTarget: (id) aTarget
{
    [slider setTarget:aTarget];
}

- (id) target
{
    return [silder target];
}


@end
