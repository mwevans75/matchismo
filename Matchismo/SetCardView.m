//
//  SetCardView.m
//  Matchismo
//
//  Created by Matthew Evans on 2/22/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@interface SetCardView()
@property (strong, nonatomic) UIColor *symbolColor;
@end

@implementation SetCardView

#define DIAMOND_HEIGHT_RATIO 0.70
#define DIAMOND_WIDTH_RATIO 0.20

#define OVAL_HEIGHT_RATIO 0.60
#define OVAL_WIDTH_RATIO 0.20

#define SQUIGGLE_HEIGHT_RATIO 0.50
#define SQUIGGLE_WIDTH_RATIO 0.15
#define SQUIGGLE_CURVE_CONTROL_POINT_RATIO 0.12
#define SQUIGGLE_CAP_CONTROL_POINT_RATIO_X 0.19
#define SQUIGGLE_CAP_CONTROL_POINT_RATIO_Y 0.12
#define SQUIGGLE_CURVE_Y_OFFSET 5.0

#define SYMBOL_HOFFSET_PERCENTAGE_1 0.0
#define SYMBOL_HOFFSET_PERCENTAGE_2 0.15
#define SYMBOL_HOFFSET_PERCENTAGE_3 0.30

#define SYMBOL_LINE_WIDTH 3.0

#define SYMBOL_STRIPE_COUNT 10

- (void)setup
{
    // initialization
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

/**************************
 *
 * Setters
 *
 **************************/
 
- (void) setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void) setColor:(NSString *)color
{
    _color = color;
    [self setSymbolColor];
    [self setNeedsDisplay];
}

- (void) setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

/**************************
 *
 * Draw Rect
 *
 **************************/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawSymbols];
}

- (void)drawSymbols
{
    if ([[SetCard validSymbols] containsObject:self.symbol]) {
        //NSLog(@"I am drawing %d %@ %@ %@", self.number, self.color, self.shading, self.symbol);
        if ([self.symbol isEqualToString:@"DIAMOND"]) {
            if (self.number == 1) {
                [self drawDiamondWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
            } else if (self.number == 2) {
                [self drawDiamondWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_2];
                [self drawDiamondWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_2];
            } else if (self.number == 3){
                [self drawDiamondWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
                [self drawDiamondWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_3];
                [self drawDiamondWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_3];
            }
        } else if ([self.symbol isEqualToString:@"OVAL"]) {
            if (self.number == 1) {
                [self drawOvalWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
            } else if (self.number == 2) {
                [self drawOvalWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_2];
                [self drawOvalWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_2];
            } else if (self.number == 3){
                [self drawOvalWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
                [self drawOvalWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_3];
                [self drawOvalWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_3];
            }
        } else if ([self.symbol isEqualToString:@"SQUIGGLE"]) {
            if (self.number == 1) {
                [self drawSquiggleWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
            } else if (self.number == 2) {
                [self drawSquiggleWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_2];
                [self drawSquiggleWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_2];
            } else if (self.number == 3){
                [self drawSquiggleWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_1];
                [self drawSquiggleWithHorizontalOffset:SYMBOL_HOFFSET_PERCENTAGE_3];
                [self drawSquiggleWithHorizontalOffset:-1*SYMBOL_HOFFSET_PERCENTAGE_3];
            }
        }
    } 
}

- (void)drawDiamondWithHorizontalOffset:(CGFloat)hoffset
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = SYMBOL_LINE_WIDTH;
    
    // Create the base Diamond
    [aPath moveToPoint:CGPointMake(self.bounds.size.width * DIAMOND_WIDTH_RATIO/2, 0)];
    [aPath addLineToPoint:CGPointMake(self.bounds.size.width * DIAMOND_WIDTH_RATIO, self.bounds.size.height * DIAMOND_HEIGHT_RATIO/2)];
    [aPath addLineToPoint:CGPointMake(self.bounds.size.width * DIAMOND_WIDTH_RATIO/2, self.bounds.size.height * DIAMOND_HEIGHT_RATIO)];
    [aPath addLineToPoint:CGPointMake(0, self.bounds.size.height * DIAMOND_HEIGHT_RATIO/2)];
    [aPath closePath];
    
    [self alignSymbol:aPath horizontalOffset:hoffset];
    
    // Stroke the line
    [self.symbolColor setStroke];
    [aPath stroke];
    
    // Fill the Path Appropriately
    if ([self.shading isEqualToString:@"SOLID"]){
        [self.symbolColor setFill];
        [aPath fill];
    } else if ([self.shading isEqualToString:@"STRIPED"]) {
        [aPath addClip];
        [self addStriping:aPath];
    }
    [self popContext];
}

- (void)drawOvalWithHorizontalOffset:(CGFloat)hoffset
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = SYMBOL_LINE_WIDTH;
    
    // Create the base Oval
    [aPath addArcWithCenter:CGPointMake(self.bounds.size.width * OVAL_WIDTH_RATIO/2, self.bounds.size.width * OVAL_WIDTH_RATIO/2)
                     radius:self.bounds.size.width * OVAL_WIDTH_RATIO/2
                 startAngle:M_PI
                   endAngle:0
                  clockwise:YES];
    [aPath addLineToPoint:CGPointMake(aPath.currentPoint.x, self.bounds.size.height * OVAL_HEIGHT_RATIO)];
    [aPath addArcWithCenter:CGPointMake(aPath.currentPoint.x - self.bounds.size.width * OVAL_WIDTH_RATIO/2, aPath.currentPoint.y)
                     radius:self.bounds.size.width * OVAL_WIDTH_RATIO/2
                 startAngle:0
                   endAngle:M_PI
                  clockwise:YES];
    [aPath closePath];
    
    [self alignSymbol:aPath horizontalOffset:hoffset];
    
    // Stroke the line
    [self.symbolColor setStroke];
    [aPath stroke];
    
    // Fill the Path Appropriately
    if ([self.shading isEqualToString:@"SOLID"]){
        [self.symbolColor setFill];
        [aPath fill];
    } else if ([self.shading isEqualToString:@"STRIPED"]) {
        [aPath addClip];
        [self addStriping:aPath];

    }
    [self popContext];
}

- (void)drawSquiggleWithHorizontalOffset:(CGFloat)hoffset
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = SYMBOL_LINE_WIDTH;
    aPath.lineJoinStyle = kCGLineJoinRound;
    
    // Create the base Squiggle
    
    [aPath moveToPoint:CGPointMake(SQUIGGLE_CURVE_CONTROL_POINT_RATIO*self.bounds.size.width,self.bounds.size.height*SQUIGGLE_CAP_CONTROL_POINT_RATIO_Y+SQUIGGLE_CURVE_Y_OFFSET)];
    [aPath addCurveToPoint:CGPointMake(aPath.currentPoint.x,aPath.currentPoint.y + self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO)
             controlPoint1:CGPointMake(aPath.currentPoint.x+self.bounds.size.width*SQUIGGLE_CURVE_CONTROL_POINT_RATIO,aPath.currentPoint.y + self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO * .33)
             controlPoint2:CGPointMake(aPath.currentPoint.x-self.bounds.size.width*SQUIGGLE_CURVE_CONTROL_POINT_RATIO,aPath.currentPoint.y + self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO * .67)];
    
    [aPath addQuadCurveToPoint:CGPointMake(aPath.currentPoint.x+self.bounds.size.width*SQUIGGLE_WIDTH_RATIO,aPath.currentPoint.y-SQUIGGLE_CURVE_Y_OFFSET)
                  controlPoint:CGPointMake(aPath.currentPoint.x+self.bounds.size.width*SQUIGGLE_CAP_CONTROL_POINT_RATIO_X,aPath.currentPoint.y+self.bounds.size.height*SQUIGGLE_CAP_CONTROL_POINT_RATIO_Y)];
    
    [aPath addCurveToPoint:CGPointMake(aPath.currentPoint.x,aPath.currentPoint.y - self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO)
             controlPoint1:CGPointMake(aPath.currentPoint.x-self.bounds.size.width*SQUIGGLE_CURVE_CONTROL_POINT_RATIO,aPath.currentPoint.y - self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO * .33)
             controlPoint2:CGPointMake(aPath.currentPoint.x+self.bounds.size.width*SQUIGGLE_CURVE_CONTROL_POINT_RATIO,aPath.currentPoint.y - self.bounds.size.height * SQUIGGLE_HEIGHT_RATIO * .67)];
    
    [aPath addQuadCurveToPoint:CGPointMake(aPath.currentPoint.x-self.bounds.size.width*SQUIGGLE_WIDTH_RATIO,aPath.currentPoint.y+SQUIGGLE_CURVE_Y_OFFSET)
                  controlPoint:CGPointMake(aPath.currentPoint.x-self.bounds.size.width*SQUIGGLE_CAP_CONTROL_POINT_RATIO_X,aPath.currentPoint.y-self.bounds.size.height*SQUIGGLE_CAP_CONTROL_POINT_RATIO_Y)];
    
    [aPath closePath];
    
    [self alignSymbol:aPath horizontalOffset:hoffset];
    
    // Stroke the line
    [self.symbolColor setStroke];
    [aPath stroke];
    
    // Fill the Path Appropriately
    if ([self.shading isEqualToString:@"SOLID"]){
        [self.symbolColor setFill];
        [aPath fill];
    } else if ([self.shading isEqualToString:@"STRIPED"]) {
        [aPath addClip];
        [self addStriping:aPath];
        
    }
    [self popContext];
}

- (void)alignSymbol:(UIBezierPath *)aPath horizontalOffset:(CGFloat)hoffset
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, (middle.x-aPath.bounds.size.width/2.0)-hoffset*self.bounds.size.width, middle.y-aPath.bounds.size.height/2.0);
}

- (void)addStriping:(UIBezierPath *)aPath
{
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i<=SYMBOL_STRIPE_COUNT; i++) {
        CGFloat lineSpacing= (CGFloat)i/(CGFloat)SYMBOL_STRIPE_COUNT;
        [bPath moveToPoint:CGPointMake(0, lineSpacing * aPath.bounds.size.height)];
        [bPath addLineToPoint:CGPointMake(self.bounds.size.width, lineSpacing * aPath.bounds.size.height)];
    }
    [bPath stroke];
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void) setSymbolColor
{
    if ([[SetCard validColors] containsObject:self.color])  {
        if ([self.color isEqualToString:@"RED"]) {
            _symbolColor = [UIColor redColor];
        } else if ([self.color isEqualToString:@"GREEN"]) {
            _symbolColor = [UIColor greenColor];
        } else if ([self.color isEqualToString:@"PURPLE"]) {
            _symbolColor = [UIColor purpleColor];
        }
    }
}

@end
