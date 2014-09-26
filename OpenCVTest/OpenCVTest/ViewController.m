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
    
    NSMutableArray *photos;
    NSMutableArray *NewPhotos;
    BOOL newData;
}

@end

@implementation ViewController {
    ImageProcessorImplementation *processor;
    
    UIImage *resultImage;
    UIImage *sourceImage;
    
    NSUInteger processingstep;
    
    NSUInteger count;
}


#pragma mark - Custom Inits

-(void) initCustomView{
    photos = [NSMutableArray new];
    for(int i = 1; i <= 13 ; i++){
        NSString *urlStr = [NSString stringWithFormat:@"l%d.jpg",i];
        MWPhoto * photo = [MWPhoto photoWithImage:[UIImage imageNamed:urlStr]];
        [photo setCaption:[NSString stringWithFormat:@"%d",i]];
        [photos addObject:photo];
    }
    
    
    NewPhotos = [NSMutableArray new];
    for(int i = 14; i <= 125 ; i++){
        NSString *urlStr = [NSString stringWithFormat:@"l%d.jpg",i];
        MWPhoto * photo = [MWPhoto photoWithImage:[UIImage imageNamed:urlStr]];
        [photo setCaption:[NSString stringWithFormat:@"%d",i]];
        [NewPhotos addObject:photo];
    }
}

#pragma mark - Standard Methods


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    count = 1;
    
    processor = [[ImageProcessorImplementation alloc] init];
    [self initCustomView];
    
//    [ImageProcessorImplementation trainSVM];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    sourceImage = inputImageView.image;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) openLibrary {
    
    // Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    // Test reloading of data after delay
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });

}

- (IBAction)takePhoto:(id)sender {
    
    outputImageView.image = nil;
    
    if (!imagePicker) {
        imagePicker = [UIImagePickerController new];
    }

    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UIActionSheet *actionSheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose From Photo library", @"Choose Existing", @"Choose Meta", nil];
        actionSheet.tag = 200;
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Choose From Photo library", @"Choose Existing", @"Choose Meta", nil];
        actionSheet.tag = 100;
    }
    [actionSheet showInView:self.view];
}

- (IBAction)processandsave:(id)sender {
    
    /*
     Perform plate detection on predefined images.
    */
    if (count<14) {
        
        [self plateInPredefinedImage:@(count)];
    }
    count++;
    
    return;
    
    /*
     Loop throuhg selected images
    */
    for (int i=1; i<=13; i++) {
        [self performSelector:@selector(plateInPredefinedImage:) withObject:@(i) afterDelay:2];
    }
    return;
    
    /*
      use selected image.
    */

    inputImageView.image = sourceImage;

    [self operation:[NSString stringWithFormat:@"l%d",count]];
    
    // We will be using source image for further processing.

}

- (void)plateInPredefinedImage:(NSNumber*)index {
    /*
     Loop through all predefined images and get result
     */
    
    UIImage *originalImage = [UIImage imageNamed:[NSString stringWithFormat:@"l%d.jpg",[index integerValue]]];
    
    if (originalImage.imageOrientation!=UIImageOrientationUp)
        sourceImage = [originalImage rotate:originalImage.imageOrientation];
    else
        sourceImage = originalImage;
    
    inputImageView.image = sourceImage;
    
    [self operation:[NSString stringWithFormat:@"l%d",[index integerValue]]];

}

- (void)operation:(NSString*)name {
    
    [activityIndicatorView startAnimating];
    [self.view bringSubviewToFront:activityIndicatorView];
    
    [ImageProcessorImplementation getLocalisedImageFromSource:sourceImage imageName:name result:^(UIImage *image) {

        dispatch_async(dispatch_get_main_queue(), ^{
         
         if (image) {
             resultImage = image;
             outputImageView.image = resultImage;
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Number plate detected." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
         }
         [activityIndicatorView stopAnimating];
        });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    CGRect croppedRect=[[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *rotatedImage;

    if (originalImage.imageOrientation!=UIImageOrientationUp)
        rotatedImage = [originalImage rotate:originalImage.imageOrientation];
    else
        rotatedImage = originalImage;

    if (rotatedImage) {
        sourceImage = nil;
        
        CGImageRef ref= CGImageCreateWithImageInRect(rotatedImage.CGImage, croppedRect);
        sourceImage= [UIImage imageWithCGImage:ref];
        CGImageRelease(ref);
    }

    [inputImageView setImage:sourceImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 100 && buttonIndex != actionSheet.cancelButtonIndex) {
     
        if (buttonIndex == 0){
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            newData = NO;
            [self openLibrary];
        }
        else if (buttonIndex == 2){
            newData = YES;
            [self openLibrary];
        }
    }
    else if(actionSheet.tag == 200 && buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0){
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if (buttonIndex == 2){
            newData = NO;
            [self openLibrary];
        }
        else if (buttonIndex == 3) {
            newData = YES;
            [self openLibrary];
        }

    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return (newData)?NewPhotos.count:photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (newData && index<NewPhotos.count) {
        return NewPhotos[index];
    }
    else if (index < photos.count && !newData) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (newData && index<NewPhotos.count) {
        return NewPhotos[index];
    }
    else if (index < photos.count && !newData) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
////    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    //    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
    

    NSUInteger index =  [photoBrowser currentIndex];
    MWPhoto * photo = (newData)?NewPhotos[index]:photos [index];
    [inputImageView setImage:photo.image];
    sourceImage = photo.image;

    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
