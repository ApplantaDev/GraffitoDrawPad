//
//  DrawPadViewController.m
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/17/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import "DrawPadViewController.h"

@implementation DrawPadViewController
@synthesize toolbar,navbar, drawerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    drawerView.brushColor = [UIColor blueColor];
    drawerView.brushWidth = 6.0f;
    
    [self setupTopNavBar];
    [self setupBottomToolBar];
}

-(void) setupTopNavBar
{
    UIBarButtonItem *cameraButton = [self createImageButtonItemWithNoTitle:@"CameraIcon" target:self action:@selector(cameraButtonPressed:)];
    self.navbar.topItem.leftBarButtonItem = cameraButton;
    
    UIBarButtonItem *shareButton = [self createImageButtonItemWithNoTitle:@"ShareIcon" target:self action:@selector(shareButtonPressed)];
    self.navbar.topItem.rightBarButtonItem = shareButton;
}

-(void) setupBottomToolBar
{
    UIBarButtonItem *barButtonUndo = [self createImageButtonItemWithNoTitle:@"UndoIcon" target:drawerView action:@selector(undoDrawing)];
    UIBarButtonItem *barButtonRedo = [self createImageButtonItemWithNoTitle:@"RedoIcon" target:drawerView action:@selector(redoDrawing)];
    UIBarButtonItem *barButtonTrash = [self createImageButtonItemWithNoTitle:@"TrashIcon" target:drawerView action:@selector(clearDrawing)];
    UIBarButtonItem *barButtonErase = [self createImageButtonItemWithNoTitle:@"EraseIcon" target:self action:@selector(eraseButtonPressed)];
    UIBarButtonItem *barButtonBrush = [self createImageButtonItemWithNoTitle:@"BrushIcon" target:self action:@selector(brushButtonPressed)];
    UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = [NSArray arrayWithObjects:barButtonUndo,barButtonRedo, barButtonFlexibleGap, barButtonBrush, barButtonFlexibleGap, barButtonErase, barButtonTrash, nil];
}

-(UIBarButtonItem *)createImageButtonItemWithNoTitle:(NSString *)imagePath target:(id)tgt action:(SEL)a
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = 32;
    buttonFrame.size.height = 32;
    [button setFrame:buttonFrame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.image = [UIImage imageNamed:imagePath];
    [button addSubview:imageView];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return buttonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action methods
- (IBAction)cameraButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Draw on an image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Import Photo", @"Take Photo", nil];
    [actionSheet showInView:self.view];
}

-(void) shareButtonPressed
{
    
}

-(void) eraseButtonPressed
{

}

-(void) brushButtonPressed
{

}


#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex != 2) {
        if (buttonIndex == 0)
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        else
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        imgPicker.allowsEditing = NO;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
        {
            image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    self.canvasImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [drawerView refreshCurrentMode];
}

@end

