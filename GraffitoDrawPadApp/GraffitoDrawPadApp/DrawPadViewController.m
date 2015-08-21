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
    

    [self determineLineColorAndWithSettings];
    self.canvasImageView.image = nil;
    
    [self setupTopNavBar];
    [self setupBottomToolBar];
    [self setupNotifications];
    
}

//Checks the user defaults to determine the settings for a users brush color and width
-(void) determineLineColorAndWithSettings
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userColor"];
    if (colorData == nil)
    {
        drawerView.lineColor = [UIColor orangeColor];
    }
    else
    {
        UIColor *selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        drawerView.lineColor = selectedColor;
    }
    
    CGFloat brushSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"userBrushSize"];
    if (brushSize <= 0.1)
    {
        drawerView.lineWidth = 6.0f;
    }
    else
    {
        drawerView.lineWidth = brushSize;
    }
}

//Configures the navigation bar for the view
-(void) setupTopNavBar
{
    UIBarButtonItem *cameraButton = [self createImageButtonItemWithNoTitle:@"CameraIcon" target:self action:@selector(cameraButtonPressed:)];
    self.navbar.topItem.leftBarButtonItem = cameraButton;
    
    UIBarButtonItem *shareButton = [self createImageButtonItemWithNoTitle:@"ShareIcon" target:self action:@selector(presentMenuFromNav:)];
    
    UIBarButtonItem *colorDisplayButton = [self createColorDisplayButton:self action:@selector(colorButtonPressed)];
    
    self.navbar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:shareButton,colorDisplayButton, nil] ;
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [image setImage: [UIImage imageNamed:@"GraffitoLogo"]];
    
    self.navbar.topItem.titleView = image;
}

//Configures the tool bar for the view
-(void) setupBottomToolBar
{
    UIBarButtonItem *barButtonUndo = [self createImageButtonItemWithNoTitle:@"UndoIcon" target:self action:@selector(undoDrawing)];
    UIBarButtonItem *barButtonRedo = [self createImageButtonItemWithNoTitle:@"RedoIcon" target:self action:@selector(redoDrawing)];
    UIBarButtonItem *barButtonTrash = [self createImageButtonItemWithNoTitle:@"TrashIcon" target:self action:@selector(trashButtonPressed)];
    UIBarButtonItem *barButtonErase = [self createImageButtonItemWithNoTitle:@"EraseIcon" target:self action:@selector(eraseButtonPressed)];
    UIBarButtonItem *barButtonBrush = [self createImageButtonItemWithNoTitle:@"BrushIcon" target:self action:@selector(brushButtonPressed)];
    UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = [NSArray arrayWithObjects:barButtonUndo,barButtonFlexibleGap,barButtonRedo, barButtonFlexibleGap, barButtonBrush, barButtonFlexibleGap, barButtonErase, barButtonFlexibleGap, barButtonTrash, nil];
}

//Register all notifications
-(void) setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveToPhotoAlbum)
                                                 name:@"Save to Photo Album"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendToMessage)
                                                 name:@"Message"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendToEmail)
                                                 name:@"Email"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBrushColor)
                                                 name:@"updateBrushColor"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBrushSize)
                                                 name:@"updateBrushSize"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupTopNavBar)
                                                 name:@"updateNavBar"
                                               object:nil];
}

//Creates the color display button
-(UIBarButtonItem *)createColorDisplayButton:(id)tgt action:(SEL)a
{
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = [colorButton frame];
    buttonFrame.size.width = 26;
    buttonFrame.size.height = 26;
    [colorButton setFrame:buttonFrame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 26, 26)];
    imageView.layer.cornerRadius = buttonFrame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 2;
    imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    [imageView setBackgroundColor:drawerView.lineColor];
    [colorButton addSubview:imageView];
    
    [colorButton addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:colorButton];
    
    return buttonItem;
}

//Creates a standard tool bar button
-(UIBarButtonItem *)createImageButtonItemWithNoTitle:(NSString *)imagePath target:(id)tgt action:(SEL)a
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = 32;
    buttonFrame.size.height = 32;
    [button setFrame:buttonFrame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 26, 26)];
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

//Initializes items for Share Menu
- (NSArray *)menuItems
{
    if (!_menuItems)
    {
        _menuItems =
        @[
          [RWDropdownMenuItem itemWithText:@"Message" image:[UIImage imageNamed:@"icon_message"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Email" image:[UIImage imageNamed:@"icon_email"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Save to Photo Album" image:[UIImage imageNamed:@"icon_album"] action:nil],
          ];
    }
    return _menuItems;
}



#pragma mark - Button Action methods
- (IBAction)cameraButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Draw on an image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Import Photo", @"Take Photo", nil];
    [actionSheet showInView:self.view];
}

- (void)presentMenuFromNav:(id)sender
{
    [RWDropdownMenu presentFromViewController:self withItems:self.menuItems align:RWDropdownMenuCellAlignmentLeft style:RWDropdownMenuStyleWhite navBarImage:[sender image] completion:nil];
}

//Fetches the images from the Canvas then saves it to the camera roll
-(void) saveToPhotoAlbum
{
    UIImage *image = [self getImageFromCanvas];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error)
     {
         NSLog(@"%@",assetURL);
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved!" message:@"Your image was successfully saved to the camera roll." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         [alert show];
     }];
}


-(UIImage*) getImageFromCanvas
{
    UIImage *drawingImage;
    if (self.canvasImageView.image ==nil)
    {
        drawingImage =  [drawerView imageRepresentation:nil];
    }
    else
    {
        drawingImage =  [drawerView imageRepresentation:self.canvasImageView];
    }
    return drawingImage;
}

//Enables the eraser
-(void) eraseButtonPressed
{
    drawerView.drawTool = ACEDrawingToolTypeEraser;
}

-(void) undoDrawing
{
    [drawerView canUndo];
    [drawerView undoLatestStep];
}

-(void) redoDrawing
{
    [drawerView canRedo];
    [drawerView redoLatestStep];
}

-(void) playButtonPressed
{
    //[drawerView animatePath];
}

-(void) colorButtonPressed
{
    drawerView.drawTool = ACEDrawingToolTypePen;
    [self performSegueWithIdentifier:@"showBrushMenu" sender:self];
}

//Enable the brush tool or show the brush menu if the brush tool is already enabled
-(void) brushButtonPressed
{
    if (drawerView.drawTool == ACEDrawingToolTypeEraser)
    {
        drawerView.drawTool = ACEDrawingToolTypePen;
    }
    else
    {
       [self performSegueWithIdentifier:@"showBrushMenu" sender:self];
    }
}

-(void) trashButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erase Canvas" message:@"The entire canvas will be erased and cannot be undone. Are you sure you want to erase?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Erase", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if (self.canvasImageView.image)
        {
            self.canvasImageView.image = nil;
        }
        [drawerView clear];
    }
}

#pragma mark - EmailComposerDelegate methods

//Opens the email composer with a nice pre-defined message
-(void) sendToEmail
{
    UIImage *image = [self getImageFromCanvas];
    MFMailComposeViewController *emailComposer = [MFMailComposeViewController new];
    emailComposer.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [emailComposer setMessageBody:@"Hi,\n\nCheck out the cool drawing I just created using Graffito Draw Pad." isHTML:NO];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        [emailComposer addAttachmentData:imageData  mimeType:@"image/jpeg" fileName:@"image.jpg"];
        [self presentViewController:emailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MessageComposerDelegate methods

//Opens the iOS message composer
-(void) sendToMessage
{
    UIImage *image = [self getImageFromCanvas];
    
    MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
    messageComposer.messageComposeDelegate = self;
    [messageComposer setBody:@""];
    NSData *imageData = UIImagePNGRepresentation(image);
    [messageComposer addAttachmentData:imageData typeIdentifier:(NSString *)kUTTypePNG   filename:@"image.png"];
    [self presentViewController:messageComposer animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - BrushMenuViewControllerDelegate methods

-(void) updateBrushColor
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userColor"];
    UIColor *selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    drawerView.lineColor = selectedColor;
}

-(void) updateBrushSize
{
    drawerView.lineWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"userBrushSize"];
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
    
    //Need to resize image view based on the size of the image imported
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Send the current brush size and color data to the brush menu view controller
    BrushMenuViewController* vc = [segue destinationViewController];
    vc.currentSelectedColor = drawerView.lineColor;
    vc.currentSelectedBrushSize = drawerView.lineWidth;
}

@end