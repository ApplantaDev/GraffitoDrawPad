//
//  DrawPadViewController.h
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPadUIView.h"
#import "BrushMenuViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RWDropdownMenu.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressHUD.h"

@interface DrawPadViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
//@property (nonatomic, unsafe_unretained) IBOutlet DrawPadUIView *drawerView;
@property (strong, nonatomic) IBOutlet UIImageView *canvasImageView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navbar;
@property (strong, nonatomic) UIColor *paintBrushColor;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) RWDropdownMenuStyle menuStyle;
@property (nonatomic, strong) DrawPadUIView *drawerView;
@property (nonatomic,strong) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *screenUIView;

@end
