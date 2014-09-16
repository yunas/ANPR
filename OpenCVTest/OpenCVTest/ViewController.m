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
    
    NSUInteger count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    count = 1;
    
    processor = [[ImageProcessorImplementation alloc] init];
    
//    [ImageProcessorImplementation trainSVM];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processandsave:(id)sender {
    
    
    // For first time our source image will be input image.
    if (count <= 14) {
        sourceImage = [UIImage imageNamed:[NSString stringWithFormat:@"l%d.jpg",count]];
        
        inputImage.image = sourceImage;
        
        [self operation:[NSString stringWithFormat:@"l%d",count]];
    }
    // We will be using source image for further processing.
    
    count++;
}

- (void)operation:(NSString*)name {
    
    resultImage = [ImageProcessorImplementation getLocalisedImageFromSource:sourceImage imageName:name]; //[processor LocalizeImageFromSource:sourceImage];
    
    outputImage.image = resultImage;
}

@end
