//
//  DrawPadUIView.h
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ACEDrawingViewVersion   1.0.0

typedef enum {
    ACEDrawingToolTypePen,
    ACEDrawingToolTypeEraser
} ACEDrawingToolType;

typedef NS_ENUM(NSUInteger, ACEDrawingMode) {
    ACEDrawingModeScale,
    ACEDrawingModeOriginalSize
};

@protocol ACEDrawingViewDelegate, ACEDrawingTool;

@interface DrawPadUIView : UIView<UITextViewDelegate>

@property (nonatomic, assign) ACEDrawingToolType drawTool;
@property (nonatomic, assign) id<ACEDrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) ACEDrawingMode drawMode;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readonly) NSUInteger undoSteps;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;
- (UIImage *)imageRepresentation: (UIImageView*) backgroundImage;

@end

#pragma mark -

@protocol ACEDrawingViewDelegate <NSObject>

@optional
- (void)drawingView:(DrawPadUIView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
- (void)drawingView:(DrawPadUIView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;

@end

