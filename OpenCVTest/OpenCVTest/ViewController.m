//
//  ViewController.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 03/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ViewController.h"
#import "ImageProcessorImplementation.h"

@interface ViewController () {
    
    __weak IBOutlet UIImageView *inputImage;
    __weak IBOutlet UIImageView *outputImage;
}

@end

@implementation ViewController {
    ImageProcessorImplementation *processor;
    
    UIImage *resultImage;
    UIImage *sourceImage;
    
    NSUInteger processingstep;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    processor = [[ImageProcessorImplementation alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processandsave:(id)sender {
    
    // For first time our source image will be input image.
    if (sourceImage == nil) {
        sourceImage = [inputImage image];
    }
    // We will be using source image for further processing.
    [self operation];
}

- (void)operation {
    
    resultImage = [processor LocalizeImageFromSource:sourceImage];
    
    outputImage.image = resultImage;
}

@end
