//
//  DrawPadUIView.m
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import "DrawPadUIView.h"

@implementation DrawPadUIView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupDrawPad];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupDrawPad];
    }
    return self;
}

#pragma mark - UI Configuration

- (void)setupDrawPad
{
    paths = [NSMutableArray new];
    _canEdit = YES;
}

- (void)setBrushColor:(UIColor *)brushColor
{
    _brushColor = brushColor;
}

#pragma mark - View Drawing

- (void)drawRect:(CGRect)rect
{
    if (!isAnimating)
    {
        [_brushColor setStroke];
        if (!isDrawingExisting)
        {
            for (UIBezierPath *path in paths)
            {
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            }
        }
        else
        {
            [bezPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        }
    }
}
- (void)drawPath:(CGPathRef)path
{
    isDrawingExisting = YES;
    _canEdit = NO;
    bezPath = [UIBezierPath new];
    bezPath.CGPath = path;
    bezPath.lineCapStyle = kCGLineCapRound;
    bezPath.lineWidth = _brushWidth;
    bezPath.miterLimit = 0.0f;
    
    // If iPad apply the scale first so the paths bounds is in its final state.
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound)
    {
        [bezPath setLineWidth:_brushWidth];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(2, 2);
        [bezPath applyTransform:scaleTransform];
    }
    
    // Center the drawing within the view.
    CGRect charBounds = bezPath.bounds;
    CGFloat charX = CGRectGetMidX(charBounds);
    CGFloat charY = CGRectGetMidY(charBounds);
    CGRect cellBounds = self.bounds;
    CGFloat centerX = CGRectGetMidX(cellBounds);
    CGFloat centerY = CGRectGetMidY(cellBounds);
    
    [bezPath applyTransform:CGAffineTransformMakeTranslation(centerX-charX, centerY-charY)];
    
    [self setNeedsDisplay];
}
- (void)drawBezier:(UIBezierPath *)path
{
    [self drawPath:path.CGPath];
}

- (void) undoDrawing
{
    [paths removeLastObject];
    [self setNeedsDisplay];
}

- (void) redoDrawing
{

}

- (void)setMode:(DrawPadMode)mode{
    
    _padMode = mode;
    [self setNeedsDisplay];
}

- (void)refreshCurrentMode
{
    [self setMode:_padMode];
}

- (void)clearDrawing
{
    bezPath = nil;
    paths = nil;
    [self setNeedsDisplay];
    [self setupDrawPad];
}
#pragma mark - View Draw Reading
- (UIImage *)imageRepresentation: (UIImageView*) backgroundImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (backgroundImage != nil) {
        [backgroundImage.layer renderInContext:context];
    }
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
//    
//    
//    CGRect rect = [self bounds];
//    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if (backgroundImage != nil) {
//       [backgroundImage.layer renderInContext:context];
//    }
//    [self.layer renderInContext:context];
//    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return capturedImage;
    
}

- (UIBezierPath *)bezierPathRepresentation
{
    UIBezierPath *singleBezPath = [UIBezierPath new];
    if (paths.count > 0)
    {
        for (UIBezierPath *path in paths)
        {
            [singleBezPath appendPath:path];
        }
    }
    else
    {
        singleBezPath = bezPath;
    }
    return singleBezPath;
}

#pragma mark - Animation

- (void)animatePath
{
    UIBezierPath *animatingPath = [UIBezierPath new];
    if (_canEdit)
    {
        for (UIBezierPath *path in paths)
        {
            [animatingPath appendPath:path];
        }
    }
    else
    {
        animatingPath = bezPath;
    }
    
    // Clear out the existing view.
    isAnimating = YES;
    [self setNeedsDisplay];
    
    // Create shape layer that stores the path.
    animateLayer = [[CAShapeLayer alloc] init];
    animateLayer.fillColor = nil;
    animateLayer.path = animatingPath.CGPath;
    animateLayer.strokeColor = [_brushColor CGColor];
    animateLayer.lineWidth = _brushWidth;
    animateLayer.miterLimit = 0.0f;
    animateLayer.lineCap = @"round";
    
    // Create animation of path of the stroke end.
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.duration = 3.0;
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.delegate = self;
    [animateLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.layer addSublayer:animateLayer];
}

#pragma mark - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    isAnimating = NO;
    [animateLayer removeFromSuperlayer];
    animateLayer = nil;
    [self setNeedsDisplay];
}

#pragma mark - Touch Detecting
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canEdit)
    {
        bezPath = [[UIBezierPath alloc] init];
        [bezPath setLineCapStyle:kCGLineCapRound];
        [bezPath setLineWidth:_brushWidth];
        [bezPath setMiterLimit:0];
        
        UITouch *currentTouch = [[touches allObjects] objectAtIndex:0];
        [bezPath moveToPoint:[currentTouch locationInView:self]];
        [paths addObject:bezPath];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canEdit)
    {
        UITouch *movedTouch = [[touches allObjects] objectAtIndex:0];
        [bezPath addLineToPoint:[movedTouch locationInView:self]];
        [self setNeedsDisplay];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}



@end
