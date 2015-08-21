//
//  BrushMenuViewController.h
//  GraffitoDrawPadApp
//
//  Created by Rahiem Klugh on 8/19/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import <QuartzCore/QuartzCore.h>

@interface BrushMenuViewController : UIViewController <ASValueTrackingSliderDataSource>
{
    NSArray *_sliders;
}
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *redSlider;
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *greenSlider;
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;
@property (nonatomic, strong) UIColor *currentSelectedColor;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *orangeButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UISlider *brushSizeSlider;
@property (nonatomic) CGFloat currentSelectedBrushSize;
@property (strong, nonatomic) IBOutlet UILabel *brushSizeLabel;

- (IBAction)redSliderChanged:(id)sender;
- (IBAction)greenSliderChanged:(id)sender;
- (IBAction)blueSliderChanged:(id)sender;
- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)brushSizeSliderChanged:(id)sender;

@end
