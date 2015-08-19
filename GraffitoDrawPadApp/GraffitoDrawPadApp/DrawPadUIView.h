//
//  DrawPadUIView.h
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    DrawPadPaintMode,
    DrawPadEraseMode
} DrawPadMode;

@interface DrawPadUIView : UIView
{
    NSMutableArray *paths;
    UIBezierPath *bezPath;
    CAShapeLayer *animateLayer;
    BOOL isAnimating;
    BOOL isDrawingExisting;
}

@property (nonatomic) UIColor *brushColor;
@property (nonatomic) CGFloat brushWidth;
@property (nonatomic) BOOL canEdit;
@property (nonatomic, readwrite) DrawPadMode padMode;
@property (nonatomic, strong) UIColor *selectedColor;

- (void) refreshCurrentMode;
- (void) drawPath:(CGPathRef)path;
- (void) drawBezier:(UIBezierPath *)path;
- (void) animatePath;
- (void) clearDrawing;
- (void) undoDrawing;
- (void) redoDrawing;
- (UIBezierPath *) bezierPathRepresentation;
- (UIImage *)imageRepresentation: (UIImageView*) backgroundImage;

@end

