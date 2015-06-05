//
//  ScanViewController.m
//  LNPR
//
//  Created by Muhammad Rashid on 04/03/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <TesseractOCR/TesseractOCR.h>

#import "ScanViewController.h"
#import "ImageProcessorImplementation.h"
#include "UIImage+operation.h"
#import "MBProgressHUD.h"
#import "AJNotificationView.h"
#import "PDFCreator.h"
#import "Utility.h"
#import "Rectangle.h"

#define kExpected   @"Expected"
#define kPractical  @"Practical"
#define kStatus     @"Status"

#import "PDFCreator.h"

#define  SAVEDPRINTER @"savedPrinter"

typedef void (^ResponseBlock)(NSString* plateNumber);
typedef void(^FailureBlock) (NSError *error);


@interface ScanViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIPrinterPickerControllerDelegate> {
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    __weak IBOutlet UIView *sessionView;
}
@property (nonatomic, setter=showPickerViews:) BOOL pickerVisible;
@property (nonatomic, setter=startLNPRProcessing:, getter=isLNPRPrcessingInProgress, assign) BOOL processing;
@property (nonatomic, strong) UIPrinter *savedPrinter;
@end

@implementation ScanViewController {

    NSMutableArray *npArray;
    NSMutableArray *cyArray;
    NSMutableArray *alphaArray;
    NSMutableArray *numberArray;
    NSMutableArray *mixArray;

    UIView *pickerContainerView;

    UIPickerView *picker01;
    UIPickerView *picker02;
    UIPickerView *picker03;
    UIPickerView *picker04;
    UIPickerView *picker05;
    UIPickerView *picker06;
    UIPickerView *picker07;
    UIPickerView *picker08;

    UIView *pickerBG01;
    UIView *pickerBG02;
    UIView *pickerBG03;
    UIView *pickerBG04;
    UIView *pickerBG05;
    UIView *pickerBG06;
    UIView *pickerBG07;
    UIView *pickerBG08;

    NSString *detectedPlateNumber;

    NSInteger arrIndex;
}

@synthesize processing = _processing;

- (void)viewDidLoad {

    [super viewDidLoad];

    [self startSession];
    [self fillDataArrays];
    [self createPickerViews];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnScreen:)];
    [self.view addGestureRecognizer:singleTap];

    UITapGestureRecognizer *doubleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHelpView:)];
    doubleTouch.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTouch];

    [singleTap requireGestureRecognizerToFail:doubleTouch];

    arrIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSURL *printerURL = [[NSUserDefaults standardUserDefaults] URLForKey:SAVEDPRINTER];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (printerURL) {
        self.savedPrinter = [UIPrinter printerWithURL:printerURL];
    }
    else {
        [self savePrinter];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark internal methods

- (void)startLNPRProcessing:(BOOL)processing {
    _processing = processing;
}

- (BOOL)isLNPRPrcessingInProgress {
    return _processing;
}

- (void)showPickerViews:(BOOL)pickerVisible {

    [AJNotificationView clearQueue];
    [Rectangle hideCameraFocusRectangle];
    _pickerVisible = pickerVisible;
    [pickerContainerView setHidden:!_pickerVisible];
}

-(AVCaptureDevice *)captureDevice {

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice hasFlash] && [captureDevice isFlashAvailable]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([captureDevice hasTorch] && [captureDevice isTorchAvailable]) {
            [captureDevice setTorchMode:AVCaptureTorchModeAuto];
        }
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
            [captureDevice setFocusPointOfInterest:autofocusPoint];
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            CGPoint exposurePoint = CGPointMake(0.5f, 0.5f);
            [captureDevice setExposurePointOfInterest:exposurePoint];
            [captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
    }
    else {
        NSLog(@"%@",[error localizedDescription]);
    }

    [captureDevice unlockForConfiguration];

    return captureDevice;
}

- (void)startSession {

    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset640x480; //AVCaptureSessionPreset640x480; //AVCaptureSessionPreset352x288; AVCaptureSessionPreset320x240; AVCaptureSessionPresetLow;

    AVCaptureDevice *device = [self captureDevice];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    if ([session canAddInput:input]) {
        [session addInput:input];
    }

    captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    CALayer *rootLayer = self.view.layer;
    [rootLayer setMasksToBounds:YES];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
    captureVideoPreviewLayer.frame = bounds;
    captureVideoPreviewLayer.backgroundColor = [[UIColor blackColor] CGColor];
    [rootLayer insertSublayer:captureVideoPreviewLayer atIndex:0];

    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection= captureVideoPreviewLayer.connection;

    if ([previewLayerConnection isVideoOrientationSupported]) [previewLayerConnection setVideoOrientation:(AVCaptureVideoOrientation)[[UIApplication sharedApplication] statusBarOrientation]];

    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG,
                                     (id)kCVPixelBufferWidthKey: @(432.f),
                                     (id)kCVPixelBufferHeightKey: @(302.f)};

    [stillImageOutput setOutputSettings:outputSettings];

    if ([session canAddOutput:stillImageOutput]) {
        [session addOutput:stillImageOutput];
    }

    [session startRunning];
}

- (void)showHelpView:(UITapGestureRecognizer *)gesture {

    [Rectangle hideCameraFocusRectangle];

    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"number of touches: %lu", (unsigned long)gesture.numberOfTouches);

        if ([self.view viewWithTag:420]) {
            NSLog(@"number of touches: %lu", (unsigned long)gesture.numberOfTouches);
            [Rectangle hideCameraFocusRectangle];
        }
        else [Rectangle showCameraFocusRectangleInView:self.view];
    }
}

- (void)didTappedOnScreen:(UITapGestureRecognizer *) gesture {

    if (_pickerVisible) {
        NSLog(@"Printer functionality started");
        [self showPickerViews:NO];
        [self printText:[self detectedPlateNumber]];
    }
    else if (![self isLNPRPrcessingInProgress] && gesture.numberOfTouches == 1 && gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"LNPR process started.");
        [self startLNPRProcessing:YES];
        [self takePicture];
    }
    else {
        NSLog(@"Already processing on a image");
    }
}

- (NSString *)detectedPlateNumber {

    NSMutableString *number = [NSMutableString stringWithString:@""];

    NSInteger index = [picker01 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:npArray[index]];
    }

    index = [picker02 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:alphaArray[index]];
    }

    index = [picker03 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:mixArray[index]];
    }

    index = [picker04 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:numberArray[index]];
    }

    index = [picker05 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:numberArray[index]];
    }

    index = [picker06 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:numberArray[index]];
    }

    index = [picker07 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:numberArray[index]];
    }

    index = [picker08 selectedRowInComponent:0];

    if (index>=0) {
        [number appendString:numberArray[index]];
    }

    NSLog(@"plate number: %@", number);

    [self resetPikcerViews];

    return number;
}

- (void)resetPikcerViews {
    [picker01 selectRow:0 inComponent:0 animated:NO];
    [picker02 selectRow:0 inComponent:0 animated:NO];
    [picker03 selectRow:0 inComponent:0 animated:NO];
    [picker04 selectRow:0 inComponent:0 animated:NO];
    [picker05 selectRow:0 inComponent:0 animated:NO];
    [picker06 selectRow:0 inComponent:0 animated:NO];
    [picker07 selectRow:0 inComponent:0 animated:NO];
    [picker08 selectRow:0 inComponent:0 animated:NO];
}

- (void)takePicture {

    // -> TODO 2
    // hand over outputImage to recognition methods
    void(^completion)(UIImage *) = ^(UIImage *capturedImage) {

        [self processandsave:capturedImage];
    };

    // -> TODO 1
    // manipulate outputImage according to fixed numberplate position

    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }

    // Update the orientation on the still image output video connection before capturing.
    [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];

    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {

         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");

         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
//        UIImageWriteToSavedPhotosAlbum(image , nil, nil, nil);
//        image = [UIImage imageNamed:@"co_circle_close.JPG"];

        CGSize size = CGSizeMake(0.5*image.size.width, 0.5*image.size.height);
        image = [image scaleImageKeepingAspectRatiotoSize:size];

        completion(image);
     }];
}

- (UIImage *)cropImageAndRotate:(UIImage *)image {

    UIImage *rotatedImage = nil;
    if (image.imageOrientation != UIImageOrientationUp) {
        rotatedImage = [image rotate:image.imageOrientation];
    }
    else
        rotatedImage = image;

    UIImage *photoImage = [rotatedImage copy];
    CGSize imageSize = photoImage.size;

    // crop 20% of original image
    CGRect imageRect = (CGRect){
        .size = imageSize
    };

    CGFloat widthFactor = imageSize.width * 0.2;
    CGFloat heightFactor = imageSize.height * 0.2;

    CGRect refRect = CGRectInset(imageRect, widthFactor, heightFactor);
    CGFloat deviceScale = photoImage.scale;
    CGImageRef imageRef = CGImageCreateWithImageInRect(photoImage.CGImage, refRect);

    UIImage *finalPhoto = [[UIImage alloc] initWithCGImage:imageRef scale:deviceScale orientation:UIImageOrientationUp];
    return finalPhoto;
}


- (NSString*)filePath:(NSString*)name {

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *filePath = [documentsPath stringByAppendingFormat:@"/%@.jpg",name];

    return filePath;
}

-(void) saveImage:(UIImage *)img {

    NSData *data = UIImageJPEGRepresentation(img, 1);
    NSError *error = nil;
    [data writeToFile:[self filePath:@"plate"] options:NSDataWritingAtomic error:&error];

    //    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
}

#pragma mark - Process LNPR

- (void)processandsave:(UIImage *)img {
    /*
     Perform plate detection on image.
     */

    [self showHudWithText:@"Detecting Number Plate..."];

    [self detectPlateNumberFromImage:img
                   withResponseBlock:^(NSString *plateNumber) {

                       if (plateNumber.length > 5) {

                           detectedPlateNumber = plateNumber;
                            // Show recognized Numbers
                           
                            [self showRecognizedNumbersWithString:plateNumber];
                            [self performSelector:@selector(checkIfUIPickerIsScrolling) withObject:nil afterDelay:1.0];
                       }
                       else {
                           [self startLNPRProcessing:NO];
                       }

                   } andErrorBlock:^(NSError *error) {

                       [[[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                        delegate:nil
                                                        cancelButtonTitle:@"ok"
                                                        otherButtonTitles:nil] show];
                       [self startLNPRProcessing:NO];
                       NSLog(@"StopLNPRProcessing => %s",__PRETTY_FUNCTION__);
                   }];
}

- (void)detectPlateNumberFromImage:(UIImage *)srcImage
                 withResponseBlock:(ResponseBlock)responseBlock
                     andErrorBlock:(FailureBlock)failureBlock
{


    dispatch_async(dispatch_queue_create("pre processing", 0), ^{

        UIImage *plateImg = [ImageProcessorImplementation numberPlateFromCarImage:srcImage
                                                                        imageName:@"imgName.png"
                                                                edgeDetectionType:EdgeDetectionTypeSobel];

        dispatch_async(dispatch_get_main_queue(), ^{

//            UIImageWriteToSavedPhotosAlbum(plateImg , nil, nil, nil);

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showHudWithText:@"Recognizing Numbers in plate."];

            if (plateImg) {

                dispatch_async(dispatch_queue_create("tesseract processing", 0), ^{

                    NSString *plateNumber = @"";
                    NSString *ocrText = [self tesseratTextFromImage:plateImg];
                    NSLog(@"ocrText: %@",ocrText);

                    if (ocrText.length) {

                        plateNumber = [[Utility sharedInstance] filterPlateNumberFromOCRString:ocrText];

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            responseBlock(plateNumber);
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No plate detected."};

                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            NSError *error = [[NSError alloc]initWithDomain:@"420" code:420 userInfo:userInfo];
                            failureBlock(error);
                        });
                    }

                });
//                [self saveImage:plateImg];
            }
            else {

                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No plate detected."};

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSError *error = [[NSError alloc]initWithDomain:@"420" code:420 userInfo:userInfo];
                failureBlock(error);
            }
        });
    });
}

#pragma mark - Tesseract

- (NSString*)tesseratTextFromImage:(UIImage*)image {

    // Create your Tesseract object using the initWithLanguage method:
    G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"deu" engineMode:G8OCREngineModeTesseractOnly];

    tesseract.delegate = self;

    // Optional: Limit the character set Tesseract should try to recognize from
    tesseract.charWhitelist = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ";
//    tesseract.charBlacklist = @"\"\".!~#$%^&*():;'<>?/Ω≈ç√∫˜µ≤≥÷æ…¬˚∆˙©ƒƒ∂å∑œ´®†¥¨π“‘«|+-_=";
    tesseract.pageSegmentationMode = G8PageSegmentationModeSingleLine|G8PageSegmentationModeSingleBlock;

    image = [UIImage imageNamed:@"img_resized.png"];

    UIImage *blacknWhite = [image g8_blackAndWhite];

    [tesseract setImage:blacknWhite];

    // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
    [tesseract setRect:CGRectMake(0.f, 0.f, image.size.width, image.size.height)];

    // Start the recognition
    [tesseract recognize];

    // Retrieve the recognized text
    NSString *recognizedText = [tesseract recognizedText];

    // You could retrieve more information about recognized text with that methods:
//    NSArray *characterBoxes = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
//    NSArray *paragraphs = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelParagraph];
    NSArray *characterChoices = tesseract.characterChoices;
//    UIImage *imageWithBlocks = [tesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];

    NSLog(@"characterChoices: %@", characterChoices);

    return recognizedText;
}


- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;
}


#pragma mark - HUD

-(void) showHudWithText:(NSString *)text {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [hud show:YES];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - Kai's Code

#pragma mark - data Methods

-(void)fillDataArrays {

    NSError *myError;

    //fill in city shorts
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kfzKennzeichen1411_neuzulassungsrelevant_KZ"
                                                         ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSMacOSRomanStringEncoding error:&myError];
    npArray = [[NSMutableArray alloc] initWithArray:[dataStr componentsSeparatedByString: @"\r"]];
    //NSLog(@"npArray filled with %lu objects",(unsigned long)[npArray count]);


    //fill in city longs
    filePath = [[NSBundle mainBundle] pathForResource:@"kfzKennzeichen1411_neuzulassungsrelevant_orte"
                                               ofType:@"csv"];
    dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSMacOSRomanStringEncoding error:&myError];
    cyArray = [[NSMutableArray alloc] initWithArray:[dataStr componentsSeparatedByString: @"\r"]];
    //NSLog(@"cyArray filled with %lu objects",(unsigned long)[cyArray count]);


    //fill in characters
    alphaArray = [[NSMutableArray alloc] initWithObjects:@"_", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    //NSLog(@"alphaArray filled with %lu objects",(unsigned long)[alphaArray count]);

    //fill in numbers
    numberArray = [[NSMutableArray alloc] initWithObjects: @"_", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    //NSLog(@"numberArray filled with %lu objects",(unsigned long)[numberArray count]);

    //fill characters and numbers
    mixArray = [[NSMutableArray alloc] initWithObjects:@"_", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"_", nil];
    //NSLog(@"numberArray filled with %lu objects",(unsigned long)[numberArray count]);

    //debug output csv files
    /*
     for (NSString *tempString in npArray) {
     NSLog(@"%@",tempString);
     }

     for (NSString *tempString in cyArray) {
     NSLog(@"%@",tempString);
     }
     */

}

#pragma mark - Picker Views

-(void)showRecognizedNumbersWithString:(NSString*)numberPlateString {

    //Split String to Single Chars
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[numberPlateString length]];
    for (int i=0; i < [numberPlateString length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [numberPlateString characterAtIndex:i]];
        [characters addObject:ichar];
    }

    //Match the chars to possible city identifier according spacing inside the numberplatestring
    int indexForCityChars = 99999;
    int numberOfFirstCityCharGroup = 0;
    int count = -1;

    bool seperatorSpaceDetected = NO;
    if ([[characters objectAtIndex:1] isEqualToString:@" "]) seperatorSpaceDetected = YES, numberOfFirstCityCharGroup=1;
    if ([[characters objectAtIndex:2] isEqualToString:@" "]) seperatorSpaceDetected = YES, numberOfFirstCityCharGroup=2;
    if ([[characters objectAtIndex:3] isEqualToString:@" "]) seperatorSpaceDetected = YES, numberOfFirstCityCharGroup=3;

    if (!seperatorSpaceDetected) {
        [self problemWithScannedNumberMessageWithCode:2];
    } else {

        for (NSString *string in npArray) {
            count++;

            if (numberOfFirstCityCharGroup==1) if ([string isEqualToString:[characters objectAtIndex:0]]) {
                indexForCityChars=count;
                break;
            }

            if (numberOfFirstCityCharGroup==2) if ([string isEqualToString:[NSString stringWithFormat:@"%@%@",[characters objectAtIndex:0], [characters objectAtIndex:1]]]) {
                indexForCityChars=count;
                break;
            }
            if (numberOfFirstCityCharGroup==3) if ([string isEqualToString:[NSString stringWithFormat:@"%@%@%@",[characters objectAtIndex:0], [characters objectAtIndex:1], [characters objectAtIndex:2]]]) {
                indexForCityChars=count;
                break;
            }
        }
    }


    // transfer the chars to the picker views

    if (indexForCityChars==99999) {

        [self problemWithScannedNumberMessageWithCode:1];

    } else {

        //City ID
        [pickerBG01 setHidden:NO];
        [picker01 selectRow:indexForCityChars inComponent:0 animated:YES];
        int digitCounter = 1;

        //Fill in the other pickers with the scanned chars
        // Picker 2
        if ((numberOfFirstCityCharGroup+1)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in alphaArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+1)] isEqualToString:tempChar]) {
                    [pickerBG02 setHidden:NO];
                    [picker02 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }
        // Picker 3
        if ((numberOfFirstCityCharGroup+2)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in mixArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+2)] isEqualToString:tempChar]) {
                    [picker03 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }
        // Picker 4
        if ((numberOfFirstCityCharGroup+3)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in numberArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+3)] isEqualToString:tempChar]) {
                    [picker04 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }

        // Picker 5
        if ((numberOfFirstCityCharGroup+4)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in numberArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+4)] isEqualToString:tempChar]) {
                    [picker05 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }

        // Picker 6
        if ((numberOfFirstCityCharGroup+5)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in numberArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+5)] isEqualToString:tempChar]) {
                    [picker06 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }

        // Picker 7
        if ((numberOfFirstCityCharGroup+6)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in numberArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+6)] isEqualToString:tempChar]) {
                    [picker07 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }

        // Picker 8
        if ((numberOfFirstCityCharGroup+7)<=([characters count]-1)) {
            count = -1;
            for (NSString *tempChar in numberArray) {
                count++;
                if ([[characters objectAtIndex:(numberOfFirstCityCharGroup+7)] isEqualToString:tempChar]) {
                    [picker08 selectRow:count inComponent:0 animated:YES];
                    break;
                }
            }
            digitCounter++;
        }

        [self showPickerViews:YES];
    }
}

-(void)problemWithScannedNumberMessageWithCode:(int)code {

    [AJNotificationView clearQueue];

    if (code==1) {

        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeGreen
                                       title:@"There seems to be a Problem with the scanned Numberplate! (Citychars do not exist)"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:1.5f];

        NSLog(@"There seems to be a Problem with the scanned Numberplate! (Citychars do not exist)");

    } else if (code==2) {

        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeOrange
                                       title:@"There seems to be a Problem with the scanned Numberplate! (Missing Space between City- and ID-Chars)"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:1.5f];
        
        NSLog(@"There seems to be a Problem with the scanned Numberplate! (Missing Space between City- and ID-Chars)");
    }

    [self startLNPRProcessing:NO];
    NSLog(@"StopLNPRProcessing => %s",__PRETTY_FUNCTION__);
}

-(void)createPickerViews {

    //Creating UIPickerviews
    pickerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [pickerContainerView setBackgroundColor:[UIColor clearColor]];
//    pickerContainerView.userInteractionEnabled = NO;
    [self.view addSubview:pickerContainerView];
    [self showPickerViews:NO];

    float spacingFactor = self.view.frame.size.width/10;
    float widthFactor = self.view.frame.size.width/10;
    NSLog(@"widthFactor:%f", widthFactor);

    pickerBG01 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG01 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker01 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker01 setTag:1];
    [picker01 setDelegate:self];
    [picker01 setDataSource:self];
    [pickerBG01 addSubview:picker01];
    [pickerContainerView addSubview:pickerBG01];

    pickerBG02 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*2, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG02 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker02 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker02 setTag:2];
    [picker02 setDelegate:self];
    [picker02 setDataSource:self];
    [pickerBG02 addSubview:picker02];
    [pickerContainerView addSubview:pickerBG02];

    pickerBG03 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*3, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG03 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker03 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker03 setTag:3];
    [picker03 setDelegate:self];
    [picker03 setDataSource:self];
    [pickerBG03 addSubview:picker03];
    [pickerContainerView addSubview:pickerBG03];

    pickerBG04 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*4, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG04 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker04 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker04 setTag:4];
    [picker04 setDelegate:self];
    [picker04 setDataSource:self];
    [pickerBG04 addSubview:picker04];
    [pickerContainerView addSubview:pickerBG04];

    pickerBG05 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*5, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG05 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker05 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker05 setTag:5];
    [picker05 setDelegate:self];
    [picker05 setDataSource:self];
    [pickerBG05 addSubview:picker05];
    [pickerContainerView addSubview:pickerBG05];

    pickerBG06 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*6, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG06 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker06 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker06 setTag:6];
    [picker06 setDelegate:self];
    [picker06 setDataSource:self];
    [pickerBG06 addSubview:picker06];
    [pickerContainerView addSubview:pickerBG06];

    pickerBG07 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*7, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG07 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker07 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker07 setTag:7];
    [picker07 setDelegate:self];
    [picker07 setDataSource:self];
    [pickerBG07 addSubview:picker07];
    [pickerContainerView addSubview:pickerBG07];

    pickerBG08 = [[UIView alloc] initWithFrame:CGRectMake(spacingFactor*8, (self.view.frame.size.height/2)-81.0, widthFactor, 162.0)];
    [pickerBG08 setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    picker08 = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthFactor, 162.0)];
    [picker08 setTag:8];
    [picker08 setDelegate:self];
    [picker08 setDataSource:self];
    [pickerBG08 addSubview:picker08];
    [pickerContainerView addSubview:pickerBG08];
 }

-(void)checkIfUIPickerIsScrolling {

    NSUInteger shownDigits = 0;

    if (![self anySubViewScrolling:pickerBG01]) {
        NSString *selValue = [npArray objectAtIndex:[picker01 selectedRowInComponent:0]];
        shownDigits = [selValue length];
    };

    if (![self anySubViewScrolling:pickerBG02]) {
        if ([picker02 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (![self anySubViewScrolling:pickerBG03]) {
        if ([picker03 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (![self anySubViewScrolling:pickerBG04]) {
        if ([picker04 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (![self anySubViewScrolling:pickerBG05]) {
        if ([picker05 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (![self anySubViewScrolling:pickerBG06]) {
        if ([picker06 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (shownDigits == 7) {
        pickerBG07.hidden = NO;
        pickerBG08.hidden = YES;

        CGRect tempFrame = pickerBG01.frame;
        [pickerBG01 setFrame:CGRectMake(self.view.frame.size.width/9, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG02.frame;
        [pickerBG02 setFrame:CGRectMake(self.view.frame.size.width/9*2, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG03.frame;
        [pickerBG03 setFrame:CGRectMake(self.view.frame.size.width/9*3, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG04.frame;
        [pickerBG04 setFrame:CGRectMake(self.view.frame.size.width/9*4, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG05.frame;
        [pickerBG05 setFrame:CGRectMake(self.view.frame.size.width/9*5, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG06.frame;
        [pickerBG06 setFrame:CGRectMake(self.view.frame.size.width/9*6, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];
        tempFrame = pickerBG07.frame;
        [pickerBG07 setFrame:CGRectMake(self.view.frame.size.width/9*7, tempFrame.origin.y, self.view.frame.size.width/9, tempFrame.size.height)];

    } else if (shownDigits == 8) {
        pickerBG07.hidden = YES;
        pickerBG08.hidden = YES;

        CGRect tempFrame = pickerBG01.frame;
        [pickerBG01 setFrame:CGRectMake(self.view.frame.size.width/8, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];
        tempFrame = pickerBG02.frame;
        [pickerBG02 setFrame:CGRectMake(self.view.frame.size.width/8*2, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];
        tempFrame = pickerBG03.frame;
        [pickerBG03 setFrame:CGRectMake(self.view.frame.size.width/8*3, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];
        tempFrame = pickerBG04.frame;
        [pickerBG04 setFrame:CGRectMake(self.view.frame.size.width/8*4, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];
        tempFrame = pickerBG05.frame;
        [pickerBG05 setFrame:CGRectMake(self.view.frame.size.width/8*5, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];
        tempFrame = pickerBG06.frame;
        [pickerBG06 setFrame:CGRectMake(self.view.frame.size.width/8*6, tempFrame.origin.y, self.view.frame.size.width/8, tempFrame.size.height)];

    } else {

        pickerBG07.hidden = NO;
        pickerBG08.hidden = NO;

        CGRect tempFrame = pickerBG01.frame;
        [pickerBG01 setFrame:CGRectMake(self.view.frame.size.width/10, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG02.frame;
        [pickerBG02 setFrame:CGRectMake(self.view.frame.size.width/10*2, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG03.frame;
        [pickerBG03 setFrame:CGRectMake(self.view.frame.size.width/10*3, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG04.frame;
        [pickerBG04 setFrame:CGRectMake(self.view.frame.size.width/10*4, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG05.frame;
        [pickerBG05 setFrame:CGRectMake(self.view.frame.size.width/10*5, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG06.frame;
        [pickerBG06 setFrame:CGRectMake(self.view.frame.size.width/10*6, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG07.frame;
        [pickerBG07 setFrame:CGRectMake(self.view.frame.size.width/10*7, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];
        tempFrame = pickerBG08.frame;
        [pickerBG08 setFrame:CGRectMake(self.view.frame.size.width/10*8, tempFrame.origin.y, self.view.frame.size.width/10, tempFrame.size.height)];

    }

    if (![self anySubViewScrolling:pickerBG07]) {
        if ([picker07 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    if (![self anySubViewScrolling:pickerBG08]) {
        if ([picker08 selectedRowInComponent:0]>0) {
            shownDigits = shownDigits+1;
        }
    };

    [self performSelector:@selector(checkIfUIPickerIsScrolling) withObject:nil afterDelay:0.5];

}

-(bool) anySubViewScrolling:(UIView*)view {

    if( [view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scroll_view = (UIScrollView*) view;
        if( scroll_view.dragging || scroll_view.decelerating )
        {
            return true;
        }
    }

    for( UIView *sub_view in [ view subviews ] )
    {
        if( [ self anySubViewScrolling:sub_view ] )
        {
            return true;
        }
    }
    
    return false;
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {

    if (pickerView.tag==1) {
        return [npArray count];
    }

    if (pickerView.tag==2) {
        return [alphaArray count];
    }

    if (pickerView.tag==3) {
        return [mixArray count];
    }

    if (pickerView.tag==4) {
        return [numberArray count];
    }

    if (pickerView.tag==5) {
        return [numberArray count];
    }

    if (pickerView.tag==6) {
        return [numberArray count];
    }

    if (pickerView.tag==7) {
        return [numberArray count];
    }

    if (pickerView.tag==8) {
        return [numberArray count];
    }

    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {

    if (pickerView.tag==1) {
        return [npArray objectAtIndex:row];
    }

    if (pickerView.tag==2) {
        return [alphaArray objectAtIndex:row];
    }

    if (pickerView.tag==3) {
        return [mixArray objectAtIndex:row];
    }

    if (pickerView.tag==4) {
        return [numberArray objectAtIndex:row];
    }

    if (pickerView.tag==5) {
        return [numberArray objectAtIndex:row];
    }

    if (pickerView.tag==6) {
        return [numberArray objectAtIndex:row];
    }

    if (pickerView.tag==7) {
        return [numberArray objectAtIndex:row];
    }

    if (pickerView.tag==8) {
        return [numberArray objectAtIndex:row];
    }
    
    return @" ";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

#pragma mark - Print

- (void)savePrinter {

    NSString *printerID = @"HP LaserJet Professional P 1102w._ipp._tcp.local";  // if you want to user printerID
    NSString *urlHostName = @"ipp://NPIA2924D.local.:631/printers/Laserjet";    // if you want use host name of printer
    NSString *urlIP = @"ipp://192.168.2.8:631/printers/Laserjet";               // if you want to use IP address of printer.

    _savedPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:urlIP]];

    return;

    UIPrinterPickerController *pickerController =[UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:_savedPrinter];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) // Large device printing
    {
        [pickerController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:^(UIPrinterPickerController *printerPickerController, BOOL userDidSelect, NSError *err){
            if (userDidSelect) {
                self.savedPrinter=printerPickerController.selectedPrinter;
                [[NSUserDefaults standardUserDefaults] setURL:self.savedPrinter.URL forKey:SAVEDPRINTER];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
    else {
        [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController *printerPickerController, BOOL userDidSelect, NSError *error) {
            if (userDidSelect) {
                self.savedPrinter = printerPickerController.selectedPrinter;

                NSLog(@"url: %@", _savedPrinter.displayName);

//                [[NSUserDefaults standardUserDefaults] setURL:self.savedPrinter.URL forKey:SAVEDPRINTER];
//                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}

- (UIViewController *)printerPickerControllerParentViewController:(UIPrinterPickerController *)printerPickerController {
    return self; // set self as parent of print picker.
}

- (void)printText:(NSString *)text {

    [self startLNPRProcessing:NO];

    if ([UIPrintInteractionController isPrintingAvailable]) {

        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];

        if (printController && _savedPrinter) {
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.duplex = UIPrintInfoDuplexNone;
            printInfo.orientation = UIPrintInfoOrientationLandscape;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = @"Plate number";
            printController.printInfo = printInfo;

            UISimpleTextPrintFormatter *formatter = [[UISimpleTextPrintFormatter alloc] initWithText:[@"PLATE NUMBER\n\n" stringByAppendingString:[text stringByReplacingOccurrencesOfString:@"_" withString:@" "]]];
            formatter.contentInsets = UIEdgeInsetsMake(72, 72, 72, 72);
            formatter.textAlignment = NSTextAlignmentCenter;
            formatter.font = [UIFont systemFontOfSize:56.0];
            printController.printFormatter = formatter;

            [printController printToPrinter:_savedPrinter completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {

                if (!completed && error) {
                    NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);

                    [[[UIAlertView alloc] initWithTitle:@"Print failed" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }
            }];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Printer not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Printer not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

@end
