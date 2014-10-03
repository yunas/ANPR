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
#import "OCRWebServiceSvc.h"

#import "MBProgressHUD.h"
#import "iToast.h"


#define kOCRWS_UserName @"ashaheen"
#define kOCRWS_License  @"4FC611E1-5782-4C9A-AEA6-8A1B88C874C8"


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
    __weak IBOutlet UIImageView *inputImageView;
    __weak IBOutlet UIImageView *outputImageView;
    
    UIImagePickerController *imagePicker;
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
    
    NSMutableArray *photos;
    NSMutableArray *bmpPhotos;
    BOOL newData;
}

@end

@implementation ViewController {
    ImageProcessorImplementation *processor;
    
    UIImage *resultImage;
    UIImage *sourceImage;
    
    NSUInteger processingstep;
    NSUInteger count;
    
    MBProgressHUD *_hud;
}

#pragma mark - Custom Inits

-(void) initCustomView{
    
    photos = [NSMutableArray new];
    for(int i = 1; i <= 30 ; i++){
        NSString *urlStr = [NSString stringWithFormat:@"l%d.JPG",i];
        MWPhoto * photo = [MWPhoto photoWithImage:[UIImage imageNamed:urlStr]];
        [photo setCaption:[NSString stringWithFormat:@"%d",i]];
        [photos addObject:photo];
    }
    
    bmpPhotos = [NSMutableArray new];
    for(int i = 1; i <= 50 ; i++){
        NSString *urlStr = [NSString stringWithFormat:@"detectsample%d.bmp",i];
        MWPhoto * photo = [MWPhoto photoWithImage:[UIImage imageNamed:urlStr]];
        [photo setCaption:[NSString stringWithFormat:@"%d",i]];
        [bmpPhotos addObject:photo];
    }
}

#pragma mark - Standard Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    NSString *testStr = @"B SB 6G3_31";
//    NSLog(@"%@",[self filterPlateNumberFromOCRString:testStr]);
//    
//    return;
    
    count = 17;
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
                                                        otherButtonTitles:@"Take photo", @"Choose From Photo library", @"Choose Existing", nil];
        actionSheet.tag = 200;
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Choose From Photo library", @"Choose Existing", nil];
        actionSheet.tag = 100;
    }
    [actionSheet showInView:self.view];
}

- (IBAction)processandsave:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Detecting number plate.";
    [hud show:YES];
    _hud = hud;
    
    /*
     Perform plate detection on predefined images.
    */
    
    resultImage = nil;
    outputImageView.image = resultImage;
    
    NSLog(@"%lu",(unsigned long)count);
    if (count<=30) {
        [self plateInPredefinedImage:@(count)];
        count++;
    }
    else {
        [[iToast makeText:@"No more test image available."] show:iToastTypeInfo];
    }
    return;
    
    /*
     Loop throuhg selected images
    */
    
//    for (int i=1; i<=78; i++) {
//        [self performSelector:@selector(plateInPredefinedImage:) withObject:@(i) afterDelay:5];
//    }
//    return;
    
    /*
      use selected image.
    */

    inputImageView.image = sourceImage;
    
    [self operation:[NSString stringWithFormat:@"l%lu",(unsigned long)count]];
    
    // We will be using source image for further processing.

}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)operation:(NSString*)name {
    
    dispatch_async(dispatch_queue_create("pre processing", 0), ^{
        
        UIImage *image = [ImageProcessorImplementation numberPlateFromCarImage:sourceImage imageName:name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [_hud hide:YES];
            
            resultImage = image;
            outputImageView.image = resultImage;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Detecting numbers in plate.";
            [hud show:YES];
            _hud = hud;
            
            if (image) {
                                
                dispatch_async(dispatch_queue_create("web service", 0), ^{
                
                    NSError *error = nil;
                    NSString *plateNumber = @"";
                    NSString *ocrText = [self OCRTextFromImage:image withError:&error];
                    if (!error) {
                        plateNumber = [self filterPlateNumberFromOCRString:ocrText];
                    }
                    else{
                        plateNumber = [error localizedDescription];
                    }

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_hud hide:YES afterDelay:0.2];
                        
                        alert.message = [NSString stringWithFormat:@"Detected plate number is \n \"%@\"",plateNumber];
                        [alert show];
                    });
                });
                
//                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.2];
                NSData *data = UIImageJPEGRepresentation(image, 1);
                NSError *error = nil;
                [data writeToFile:[self filePath:[NSString stringWithFormat:@"plate%lu",(unsigned long)count]] options:NSDataWritingAtomic error:&error];
            }
            else {
                
                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.2];

                alert.message = @"No plate detected.";
                [alert show];
                
                NSLog(@"number plate not found for image:%lu.JPG",(unsigned long)count-1);
            }
        });
    });
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
        sourceImage= [[UIImage imageWithCGImage:ref] scaleImageKeepingAspectRatiotoSize:CGSizeMake(432.f, 302.f)];
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
    return (newData)?bmpPhotos.count:photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (newData && index<bmpPhotos.count) {
        return bmpPhotos[index];
    }
    else if (index < photos.count && !newData) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (newData && index<bmpPhotos.count) {
        return bmpPhotos[index];
    }
    else if (index < photos.count && !newData) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    //    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");

    NSUInteger index =  [photoBrowser currentIndex];
    MWPhoto * photo = (newData)?bmpPhotos[index]:photos [index];
    [inputImageView setImage:photo.image];
    sourceImage = photo.image;

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private method

- (NSString*)filePath:(NSString*)name {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingFormat:@"/%@.jpg",name];
    
    return filePath;
}


- (void)plateInPredefinedImage:(NSNumber*)index {
    /*
     Loop through all predefined images and get result
    */
    
    NSString *path =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"l%ld.JPG",(long)[index integerValue]] ofType:nil];
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:path];
    
    if (!originalImage) {
        [_hud hide:YES];
        return;
    }
    
    if (originalImage.imageOrientation!=UIImageOrientationUp)
        sourceImage = [originalImage rotate:originalImage.imageOrientation];
    else
        sourceImage = originalImage;
    
    inputImageView.image = sourceImage;
    
    [self operation:[NSString stringWithFormat:@"l%ld",(long)[index integerValue]]];
}


-(NSString *) stringWithNumbersOnly:(NSString*)str{
    
    NSString *numberStr = [NSString stringWithString:str];
    
    numberStr = [numberStr stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [numberStr length])];
    return numberStr;
    
}

-(NSString *) stringWithAlphabetsOnly:(NSString *)str{
    NSString *alphaStr = [NSString stringWithString:str];
    alphaStr = [alphaStr stringByReplacingOccurrencesOfString:@"[^A-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [alphaStr length])];
    return alphaStr;
}

-(NSString *) stringWithoutPunctuations:(NSString *)str{
    NSString *filteredStr = [NSString stringWithString:str];
    filteredStr = [filteredStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"[^A-Z0-9 ]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [filteredStr length])];
    return filteredStr;
}


-(NSString *) filterPlateNumberFromOCRString:(NSString *)ocrText{
    
    NSString *filteredStr = [NSString stringWithString:ocrText];

    
    filteredStr = [self stringWithoutPunctuations:filteredStr];
    
    NSArray *platesPart = [filteredStr componentsSeparatedByString:@" "];
    
    if (platesPart.count == 3) {
        NSString *parta = [self stringWithAlphabetsOnly:platesPart[0]];
        NSString *partb = [self stringWithAlphabetsOnly:platesPart[1]];
        NSString *partc = [self stringWithNumbersOnly:platesPart[2]];
        filteredStr = [NSString stringWithFormat:@"%@ %@ %@",parta,partb,partc];
    }
    
    if (platesPart.count == 2) {
        NSString *parta = [self stringWithAlphabetsOnly:platesPart[0]];
        NSString *partb = platesPart[1];//[self stringWithNumbersOnly:platesPart[1]];
        filteredStr = [NSString stringWithFormat:@"%@ %@",parta,partb];
    }

    return filteredStr;
}

#pragma mark - WEB SERVICES



-(NSString*) OCRTextFromImage:(UIImage*)image withError:(NSError * __autoreleasing *)error {
    
    
    OCRWebServiceSoapBinding *binding = [OCRWebServiceSvc OCRWebServiceSoapBinding];
    [binding setLogXMLInOut:NO];
    
    
    OCRWebServiceSvc_OCRWebServiceRecognize *params = [[OCRWebServiceSvc_OCRWebServiceRecognize alloc]init];
    [params setUser_name:kOCRWS_UserName];
    [params setLicense_code:kOCRWS_License];
    
    OCRWebServiceSvc_OCRWSInputImage *inputImg = [[OCRWebServiceSvc_OCRWSInputImage alloc]init];
    
    [inputImg setFileData:UIImageJPEGRepresentation(image, 1)];
    [inputImg setFileName:@"plate1.jpg"];
    
    [params setOCRWSInputImage:inputImg];
    
    OCRWebServiceSvc_OCRWSSettings *settings = [[OCRWebServiceSvc_OCRWSSettings alloc]init];
    
    [settings setOutputDocumentFormat:OCRWebServiceSvc_OCRWS_OutputFormat_TXT];
    
    [settings setConvertToBW:[[USBoolean alloc]initWithBool:NO]];
    [settings setGetOCRText:[[USBoolean alloc]initWithBool:YES]];
    [settings setCreateOutputDocument:[[USBoolean alloc]initWithBool:NO]];
    [settings setMultiPageDoc:[[USBoolean alloc]initWithBool:NO]];
    [settings setOcrWords:[[USBoolean alloc]initWithBool:NO]];
    [settings addOcrLanguages:OCRWebServiceSvc_OCRWS_Language_ENGLISH];
    
    
    [params setOCRWSSetting:settings];
    
    
    OCRWebServiceSoapBindingResponse *response = [binding OCRWebServiceRecognizeUsingParameters:params];
    
    NSString *plateNumber = @"";
    
    for(id bodyPart in response.bodyParts) {
        if([bodyPart isKindOfClass:[OCRWebServiceSvc_OCRWebServiceRecognizeResponse class]]) {
            OCRWebServiceSvc_OCRWebServiceRecognizeResponse *oResponse = (OCRWebServiceSvc_OCRWebServiceRecognizeResponse*)bodyPart;
            OCRWebServiceSvc_ArrayOfArrayOfString *ocrTextsArr = oResponse.OCRWSResponse.ocrText;
            OCRWebServiceSvc_ArrayOfString *strings = [ocrTextsArr.ArrayOfString lastObject];
            plateNumber = [strings.string lastObject];
            break;
        }
    }
   
    if (response.error) {
        plateNumber = [response.error localizedDescription];
        *error = [NSError errorWithDomain:response.error.domain code:response.error.code userInfo:response.error.userInfo] ;
    }
    
    NSLog(@"WEB-OCR-TEXT: %@",plateNumber);
    
    return plateNumber;
}

@end
