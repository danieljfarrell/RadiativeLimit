@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation CellBarChartView : CPView
{
    double voltageSQCell @accessors;
    double voltageHCCell @accessors;
    double maxVoltage @accessors;
    double currentSQCell @accessors;
    double currentHCCell @accessors;
    double maxCurrent @accessors;
    double efficiencySQCell @accessors;
    double efficiencyHCCell @accessors;
    double xspacer @accessors;
    double yspacer @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    maxVoltage = 3.0;
    maxCurrent = 1000.0;
    xorigin = 100.;
    xspacer = aFrame.size.width * 0.05;
    yspacer = aFrame.size.height * 0.1;
    return self;
}

- (void) drawRect: (CGRect) aRect
{   
    // make 3 bars: voltage, current and power.

    //thickness = ([self bounds].size.height - 12.*yspacer) / 6.0;
    thickness = 30;
    barMaxExtent = [self bounds].size.width - xspacer - xorigin;
    voltageBarSQCell = CPMakeRect(xorigin, yspacer, [self voltageSQCell]/maxVoltage * barMaxExtent, thickness);
    currentBarSQCell = CPMakeRect(xorigin, yspacer*2. + 2.*thickness, [self currentSQCell]/maxCurrent * barMaxExtent, thickness);
    efficiencyBarSQCell = CPMakeRect(xorigin, yspacer*3. + 4.*thickness, [self efficiencySQCell] * barMaxExtent, thickness);
    
    [[CPColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:0.5] set];
    //[CPBezierPath fillRect:voltageBarSQCell];
    //CPBezierPath fillRect:currentBarSQCell];
    //  [CPBezierPath fillRect:efficiencyBarSQCell];
    var path1 = [CPBezierPath bezierPath];
    [path1 appendBezierPathWithRoundedRect:voltageBarSQCell xRadius:10 yRadius:10];
    [path1 fill];
    
    var path2 = [CPBezierPath bezierPath];
    [path2 appendBezierPathWithRoundedRect:currentBarSQCell xRadius:10 yRadius:10];
    [path2 fill];
    
    var path3 = [CPBezierPath bezierPath];
    [path3 appendBezierPathWithRoundedRect:efficiencyBarSQCell xRadius:10 yRadius:10];
    [path3 fill];
    
    
    voltageBarHCCell = CPMakeRect(xorigin, 3+ yspacer + thickness, [self voltageHCCell]/maxVoltage * barMaxExtent, thickness);
    currentBarHCCell = CPMakeRect(xorigin, 3+yspacer*2. + 3.*thickness, [self currentHCCell]/maxCurrent * barMaxExtent, thickness);
    efficiencyBarHCCell = CPMakeRect(xorigin, 3+yspacer*3. + 5.*thickness, [self efficiencyHCCell] * barMaxExtent, thickness);
    [[CPColor colorWithRed:0.6 green:0.1 blue:0.2 alpha:0.5] set];
    var path4 = [CPBezierPath bezierPath];
    [path4 appendBezierPathWithRoundedRect:voltageBarHCCell xRadius:10 yRadius:10];
    [path4 fill];
    
    var path5 = [CPBezierPath bezierPath];
    [path5 appendBezierPathWithRoundedRect:currentBarHCCell xRadius:10 yRadius:10];
    [path5 fill];
    
    var path6 = [CPBezierPath bezierPath];
    [path6 appendBezierPathWithRoundedRect:efficiencyBarHCCell xRadius:10 yRadius:10];
    [path6 fill];
    
    //[CPBezierPath fillRect:voltageBarHCCell];
    //[CPBezierPath fillRect:currentBarHCCell];
    //[CPBezierPath fillRect:efficiencyBarHCCell];
    
    var voltageLabel = [[CPTextField alloc] initWithFrame:CPMakeRect(10, 50,0.,0.)];
    [voltageLabel setStringValue:@"Voltage"];
    [voltageLabel setFont:[CPFont systemFontOfSize:16.0]];
    [voltageLabel sizeToFit];
    
    var currentLabel = [[CPTextField alloc] initWithFrame:CPMakeRect(10,142,0,0)];
    [currentLabel setStringValue:@"Current"];
    [currentLabel setFont:[CPFont systemFontOfSize:16.0]];
    [currentLabel sizeToFit];

    var efficiencyLabel = [[CPTextField alloc] initWithFrame:CPMakeRect(10,230,0,0)];
    [efficiencyLabel setStringValue:@"Efficiency"];
    [efficiencyLabel setFont:[CPFont systemFontOfSize:16.0]];
    [efficiencyLabel sizeToFit];
    
    [self addSubview:voltageLabel];
    [self addSubview:currentLabel];
    [self addSubview:efficiencyLabel];
    
    var efficiencyValue = [[CPTextField alloc] initWithFrame:CPMakeRect(350,230,0,0)];
    [efficiencyValue setStringValue:@"0.73"];
    [efficiencyValue setFont:[CPFont systemFontOfSize:16.0]];
    [efficiencyValue sizeToFit];
    
    [self addSubview:efficiencyValue];
    
    //Uncomment this
    [[CPColor blackColor] set];
    [CPBezierPath strokeRect:[self bounds]];
}

@end