//
//  ViewController.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 03/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ViewController.h"
#import "ImageProcessorImplementation.h"
#include "UIImage+operation.h"


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
    __weak IBOutlet UIImageView *inputImageView;
    __weak IBOutlet UIImageView *outputImageView;
    
    UIImagePickerController *imagePicker;
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    sourceImage = inputImageView.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    
    outputImageView.image = nil;
    
    if (!imagePicker) {
        imagePicker = [UIImagePickerController new];
    }

    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)processandsave:(id)sender {
    
    [self operation:@"numberplate.jpg"];
    
    return;
    
    // For first time our source image will be input image.
    if (count <= 14) {
        sourceImage = [UIImage imageNamed:[NSString stringWithFormat:@"l%d.jpg",count]];
        
        inputImageView.image = sourceImage;
        
        [self operation:[NSString stringWithFormat:@"l%d",count]];
    }
    // We will be using source image for further processing.
    
    count++;
}

- (void)operation:(NSString*)name {
    
    [activityIndicatorView startAnimating];
    
    [ImageProcessorImplementation getLocalisedImageFromSource:sourceImage imageName:name result:^(UIImage *image) {

     dispatch_async(dispatch_get_main_queue(), ^{
         resultImage = image;
         outputImageView.image = resultImage;
         [activityIndicatorView stopAnimating];
     });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *rotatedImage;

    if (originalImage.imageOrientation!=UIImageOrientationUp)
        rotatedImage = [originalImage rotate:originalImage.imageOrientation];
    else
        rotatedImage = originalImage;

    if (rotatedImage) {
        sourceImage = nil;
        sourceImage= rotatedImage; //[UIImage imageWithCGImage:ref];
    }

    [inputImageView setImage:sourceImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0)
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        else if (buttonIndex == 1)
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
