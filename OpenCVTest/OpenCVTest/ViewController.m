//
//  ViewController.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 03/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    __weak IBOutlet UIImageView *inputImage;
    __weak IBOutlet UIImageView *outputImage;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processandsave:(id)sender {
    
//    cv::Mat source = [inputImage.image CVMat];
}
@end
