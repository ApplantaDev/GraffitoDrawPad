//
//  BrushMenuViewController.m
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/19/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import "BrushMenuViewController.h"

@interface BrushMenuViewController ()

@end

@implementation BrushMenuViewController
@synthesize redButton, greenButton, blueButton, orangeButton, blackButton, yellowButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTopNavBar];
    [self setupColorSliders];
    [self refreshBrushSize];
    
}

//Configures the color sliders to the current selection when the view first loads
-(void) setupColorSliders
{
    const CGFloat *_components = CGColorGetComponents(self.currentSelectedColor.CGColor);
    CGFloat red     = _components[0];
    CGFloat green = _components[1];
    CGFloat blue   = _components[2];
    
    self.colorImageView.layer.cornerRadius = 15;
    self.colorImageView.layer.borderWidth = 3;
    self.colorImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.colorImageView setBackgroundColor:self.currentSelectedColor];
    
    // Red Slider
    self.redSlider.maximumValue = 100.0;
    self.redSlider.popUpViewCornerRadius = 0.0;
    [self.redSlider setMaxFractionDigitsDisplayed:0];
    self.redSlider.popUpViewColor = [UIColor colorWithRed:201.0/255.0 green:48.0/255.0 blue:40.0/255.0 alpha:0.8];
    self.redSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.redSlider.textColor = [UIColor whiteColor];
    self.redSlider.popUpViewWidthPaddingFactor = 1.7;
    self.redSlider.value = (red*100);
    
    // Green Slider
    self.greenSlider.maximumValue = 100.0;
    self.greenSlider.popUpViewCornerRadius = 0.0;
    [self.greenSlider setMaxFractionDigitsDisplayed:0];
    self.greenSlider.popUpViewColor = [UIColor colorWithRed:32.0/255.0 green:158.0/255.0 blue:38.0/255.0 alpha:0.8];
    self.greenSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.greenSlider.textColor = [UIColor whiteColor];
    self.greenSlider.popUpViewWidthPaddingFactor = 1.7;
    self.greenSlider.value = (green*100);
    
    // Blue SLider
    self.blueSlider.maximumValue = 100.0;
    self.blueSlider.popUpViewCornerRadius = 0.0;
    [self.blueSlider setMaxFractionDigitsDisplayed:0];
    self.blueSlider.popUpViewColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.8];
    self.blueSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.blueSlider.textColor = [UIColor whiteColor];
    self.blueSlider.popUpViewWidthPaddingFactor = 1.7;
    self.blueSlider.value = (blue*100);
    
    _sliders = @[_redSlider, _greenSlider, _blueSlider];
}

//Adjusts the brush size to the current selection when the view first loads
-(void) refreshBrushSize
{
    self.brushSizeSlider.value = self.currentSelectedBrushSize;
    int y = (int)self.brushSizeSlider.value;
    self.brushSizeLabel.text = [NSString stringWithFormat:@"%d",y];
    [self.brushSizeLabel setFont: [self.brushSizeLabel.font fontWithSize: (y+15)]];
}

//Changes the selected color based on a preset color being prerssed
- (IBAction)colorButtonPressed:(id)sender {
    
    switch ([sender tag]) {
        case 1:
        {
            [self changeColor:CGColorGetComponents(blueButton.backgroundColor.CGColor)];
        }
            break;
        case 2:
        {
            [self changeColor:CGColorGetComponents(greenButton.backgroundColor.CGColor)];
        }
            break;
        case 3:
        {
            [self changeColor:CGColorGetComponents(redButton.backgroundColor.CGColor)];
        }
            break;
        case 4:
        {
            [self changeColor:CGColorGetComponents(orangeButton.backgroundColor.CGColor)];
        }
            break;
        case 5:
        {
            [self changeColor:CGColorGetComponents(blackButton.backgroundColor.CGColor)];
        }
            break;
        case 6:
        {
            [self changeColor:CGColorGetComponents(yellowButton.backgroundColor.CGColor)];
        }
            break;
            
        default:
            break;
    }
    
    [self setResultColor];
}

-(void) changeColor: (const CGFloat*) components
{
    CGFloat red     = components[0];
    CGFloat green = components[1];
    CGFloat blue   = components[2];
    
    self.redSlider.value = (red*100);
    self.greenSlider.value = (green*100);
    self.blueSlider.value  = (blue*100);
}

- (IBAction)redSliderChanged:(id)sender
{
    [self setResultColor];
}
- (IBAction)greenSliderChanged:(id)sender
{
    [self setResultColor];
}
- (IBAction)blueSliderChanged:(id)sender
{
    [self setResultColor];
}

//Updates the brush size width and increases the font based on the value
- (IBAction)brushSizeSliderChanged:(id)sender
{
    UISlider *slider = sender;
    self.currentSelectedBrushSize = slider.value;
    int y = (int)self.currentSelectedBrushSize;
    self.brushSizeLabel.text = [NSString stringWithFormat:@"%d",y];
    [self.brushSizeLabel setFont: [self.brushSizeLabel.font fontWithSize: (y+15)]];
}

- (void)setResultColor
{
    CGFloat r,g,b;
    
    r = self.redSlider.value;
    g = self.greenSlider.value;
    b = self.blueSlider.value;
    
    [self.colorImageView setBackgroundColor:[UIColor colorWithRed:r/100 green:g/100 blue:b/100 alpha:1.0]];
}

- (void)animateSlider:(ASValueTrackingSlider*)slider toValue:(float)value
{
    [slider setValue:value animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Configures the navigation bar for the view
-(void) setupTopNavBar
{
    UIBarButtonItem *cancelButton = [self createImageButtonItemWithNoTitle:@"CancelIcon" target:self action:@selector(cancelButtonPressed)];
    self.navBar.topItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *DoneButton = [self createImageButtonItemWithNoTitle:@"CheckIcon" target:self action:@selector(doneButtonPressed)];
    self.navBar.topItem.rightBarButtonItem = DoneButton;
}

-(UIBarButtonItem *)createImageButtonItemWithNoTitle:(NSString *)imagePath target:(id)tgt action:(SEL)a
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = 32;
    buttonFrame.size.height = 32;
    [button setFrame:buttonFrame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 25, 25)];
    imageView.image = [UIImage imageNamed:imagePath];
    [button addSubview:imageView];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return buttonItem;
    
}

-(void) cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Saves the brush size and color data to the user defaults
-(void) doneButtonPressed
{
    UIColor *color = self.colorImageView.backgroundColor;
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"userColor"];
    [[NSUserDefaults standardUserDefaults] setFloat: self.currentSelectedBrushSize forKey:@"userBrushSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBrushColor" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBrushSize" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNavBar" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Disables landscape rotation for this view
- (BOOL)shouldAutorotate {
    return NO;
}


@end
