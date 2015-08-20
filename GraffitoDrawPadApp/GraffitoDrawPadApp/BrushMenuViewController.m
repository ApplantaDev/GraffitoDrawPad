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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTopNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void) doneButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
