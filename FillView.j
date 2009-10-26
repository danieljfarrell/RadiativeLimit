@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation FillView : CPView
{
    var filledRect;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    //[self setBackgroundColor: [CPColor whiteColor]];
    filledRect = CPMakeRect(0.0 ,0.0, CPRectGetWidth(aFrame), CPRectGetHeight(aFrame));
    return self;
}

- (CGRect) filledRect
{
    return filledRect;
}

- (void) setFilledRect: (CGRect) aRect
{
    filledRect = aRect;
}

- (void) drawRect: (CGRect) aRect
{   
    CPLogConsole(@"drawRect:");
    CPLogConsole(CPStringFromRect(filledRect));
    [[CPColor colorWithRed:0.0 green:0.8 blue:0.2 alpha:0.5] set];
    [CPBezierPath fillRect:filledRect];
    CPLogConsole(@"exit drawRect:");
}

@end