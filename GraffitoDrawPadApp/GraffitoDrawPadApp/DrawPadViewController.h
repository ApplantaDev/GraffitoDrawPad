//
//  DrawPadViewController.h
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPadUIView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DrawPadViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet DrawPadUIView *drawerView;
@property (strong, nonatomic) IBOutlet UIImageView *canvasImageView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navbar;
@property (strong, nonatomic) UIColor *paintBrushColor;

@end
