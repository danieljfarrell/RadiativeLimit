@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation FillView : CPView
{
    double xFillFraction;
    var width;
    var height;
    var yOrigin;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    //[self setBackgroundColor: [CPColor whiteColor]];
    width = CPRectGetWidth(aFrame)
    height = CPRectGetHeight(aFrame)
    yOrigin = CPRectGetMinY(aFrame)
    filledRect = CPMakeRect(0.0 ,0.0, width, height);
    return self;
}

- (void) setXFillFraction: (double) aDouble
{
    xFillFraction = aDouble;
}

- (double) xFillFraction
{
    return xFillFraction;
}

- (void) drawRect: (CGRect) aRect
{   
    CPLogConsole(@"drawRect:");
    [[CPColor colorWithRed:0.0 green:0.8 blue:0.2 alpha:0.5] set];
    var filledRect = CPRectCreateCopy([self bounds]);
    filledRect.origin.x = xFillFraction*width;
    filledRect.size.width = width - filledRect.origin.x;
    [CPBezierPath fillRect:filledRect];
    [CPBezierPath strokeRect:[self bounds]];
    CPLogConsole(@"exit drawRect:");
}

@end