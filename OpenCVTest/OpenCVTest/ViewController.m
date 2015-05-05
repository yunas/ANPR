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

#import <TesseractOCR/TesseractOCR.h>

#import "MBProgressHUD.h"
#import "iToast.h"
#import "PDFCreator.h"
#import "CameraView.h"
#import "Utility.h"


#define kOCRWS_UserName @"ashaheen"
#define kOCRWS_License  @"4FC611E1-5782-4C9A-AEA6-8A1B88C874C8"

#define kExpected   @"Expected"
#define kPractical  @"Practical"
#define kStatus     @"Status"

#import "PDFCreator.h"


typedef void (^ResponseBlock)(NSString* plateNumber);
typedef void(^FailureBlock) (NSError *error);


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, G8TesseractDelegate> {
    
    __weak IBOutlet UIImageView *inputImageView;
    __weak IBOutlet UIImageView *outputImageView;
    
    UIImagePickerController *imagePicker;
    
    NSMutableArray *photos;
    
    NSInteger count;
}

@end

@implementation ViewController {
    ImageProcessorImplementation *processor;
    NSDictionary *numberPlates;
    NSMutableArray *reportsArr;
}

#pragma mark - Custom Inits

-(void) initCustomView{
    
    photos = [NSMutableArray new];
    for(int i = 1; i <= 36 ; i++){
        NSString *urlStr = [NSString stringWithFormat:@"l%d.JPG",i];
        MWPhoto * photo = [MWPhoto photoWithImage:[UIImage imageNamed:urlStr]];
        [photo setCaption:[NSString stringWithFormat:@"%d",i]];
        [photos addObject:photo];
    }
}


#pragma mark - Automation


- (void)generatePdf {
    
    PDFCreator *pdfCreator = [PDFCreator new];
    NSString *reportPath = [pdfCreator generatePdf:reportsArr];
    [self shareReportViaMail:reportPath];
    
}


-(void) saveResult:(NSString *)response forIndex:(int)index{
  
    if ([[numberPlates objectForKey:[NSString stringWithFormat:@"l%d",index]] isEqualToString:response]) {
            NSDictionary *dict = @{@"Expected":[numberPlates objectForKey:[NSString stringWithFormat:@"l%d",index]],
                                   @"Observed":response,
                                   @"Status":@"Matched"};
        [reportsArr addObject:dict];
    }
    else{
        NSDictionary *dict = @{@"Expected":[numberPlates objectForKey:[NSString stringWithFormat:@"l%d",index]],
                               @"Observed":response,
                               @"Status":@"NotMatched"};
        
        [reportsArr addObject:dict];
    }
}

-(void) automateFromIndex:(int)fromIndex toImageIndex:(int)toIndex{

    if (fromIndex <= toIndex) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"l%d.JPG",fromIndex]];
        [inputImageView setImage:image];
        
        [self detectPlateNumberFromImage:image withResponseBlock:^(NSString *plateNumber) {
            [self saveResult:plateNumber forIndex:fromIndex];
            
            sleep(3);
            
            [self automateFromIndex:fromIndex+1 toImageIndex:toIndex];
            
        } andErrorBlock:^(NSError *error) {
            [self saveResult:error.localizedDescription forIndex:fromIndex];
            NSLog(@"%@",error.localizedDescription);
            [self automateFromIndex:fromIndex+1 toImageIndex:toIndex];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    else if (fromIndex > toIndex) {
        [self generatePdf];
        count = 0;
    }
    count++;
}

#pragma mark - Standard Methods
-(void) initTest{
//    [self generatePdf];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    processor = [[ImageProcessorImplementation alloc] init];
    [self initCustomView];
    [self performSelector:@selector(initTest) withObject:nil afterDelay:2.0];
    
    count = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
- (IBAction)automateProcess:(id)sender {
  
    numberPlates = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NumberPlates" ofType:@"plist"]];
    reportsArr = [NSMutableArray new];
    
    [self automateFromIndex:1 toImageIndex:36];
}

- (IBAction)takePhoto:(id)sender {
    
    outputImageView.image = nil;
    
    if (!imagePicker) {
        imagePicker = [UIImagePickerController new];
    }
    
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    
    UIActionSheet *actionSheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo",
                                                                          @"Choose From Photo library",
                                                                          @"Choose Existing",
                                                                          nil];
        actionSheet.tag = 200;
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo or choose existing photo."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Choose From Photo library",
                                                                          @"Choose Existing",
                                                                          nil];
        actionSheet.tag = 100;
    }
    [actionSheet showInView:self.view];
}

- (void)didTaptakePictureButton:(UIButton*)sender {
    [imagePicker takePicture];
}

-(void) showHudWithText:(NSString *)text{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [hud show:YES];
}

- (IBAction)processandsave:(id)sender {
    
    /*
     Perform plate detection on predefined images.
    */
    
    [self showHudWithText:@"Detecting Number Plate..."];
    [self detectPlateNumberFromImage:inputImageView.image
                   withResponseBlock:^(NSString *plateNumber) {
                       NSString* message = [NSString stringWithFormat:@"Detected plate number is \n \"%@\"",plateNumber];

                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                                      message:message
                                                                     delegate:nil
                                                            cancelButtonTitle:@"ok"
                                                            otherButtonTitles:nil];
                       [alert show];
                       
                   } andErrorBlock:^(NSError *error) {
                       
                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                      message:error.localizedDescription
                                                                     delegate:nil
                                                            cancelButtonTitle:@"ok"
                                                            otherButtonTitles:nil];
                       [alert show];
                       
                   }];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void) saveImage:(UIImage *)img{
  
    NSData *data = UIImageJPEGRepresentation(img, 1);
    NSError *error = nil;
    [data writeToFile:[self filePath:[NSString stringWithFormat:@"plateImg_%ld",(long)count]] options:NSDataWritingAtomic error:&error];
    
//    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
   
}

- (NSString*)tesseratTextFromImahe:(UIImage*)image {
    
    // Create your Tesseract object using the initWithLanguage method:
    G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"deu" engineMode:G8OCREngineModeTesseractCubeCombined];
    
    tesseract.delegate = self;

    // Optional: Limit the character set Tesseract should try to recognize from
    tesseract.charWhitelist = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ";
    //    [tesseract setVariableValue:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ" forKey:@"tessedit_char_whitelist"];

    tesseract.pageSegmentationMode = G8PageSegmentationModeSingleLine;

    UIImage *blacknWhite = [image g8_blackAndWhite];

    [tesseract setImage:blacknWhite];
    
    // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
    [tesseract setRect:CGRectMake(0.f, 0.f, image.size.width, image.size.height)];
    
    // Start the recognition
    [tesseract recognize];
    
    // Retrieve the recognized text
    return [tesseract recognizedText];
    
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

            outputImageView.image = plateImg;
            [self hideHUD];
            [self showHudWithText:@"Recognizing Numbers in plate."];
            
            if (plateImg) {
                                
                dispatch_async(dispatch_queue_create("web service", 0), ^{
                
                    NSError *error = nil;
                    NSString *plateNumber = @"";
                    NSString *ocrText = [self tesseratTextFromImahe:plateImg]; // [self OCRTextFromImage:plateImg withError:&error];
                    NSLog(@"plate number: %@",ocrText);
                    
                    if (!error) {
                        plateNumber = [[Utility sharedInstance] filterPlateNumberFromOCRString:ocrText];
                    }
                    else{
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No number detected."};
                       
                        NSError *error1 = [[NSError alloc]initWithDomain:@"421" code:421 userInfo:userInfo];
                        failureBlock(error1);
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
  
                        [self hideHUD];
                        responseBlock(plateNumber);
                    });
                });
                
                [self saveImage:plateImg];
            }
            else {
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No plate detected."};
                
                [self hideHUD];
                NSError *error = [[NSError alloc]initWithDomain:@"420" code:420 userInfo:userInfo];
                failureBlock(error);
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
        if (!CGRectIsEmpty(croppedRect)) {
            
            CGImageRef ref= CGImageCreateWithImageInRect(rotatedImage.CGImage, croppedRect);
            
            UIImage *img = [UIImage imageWithCGImage:ref];
            inputImageView.image= [img resizeImageToWidth:432.f];
            
            CGImageRelease(ref);
        }
        else {
            inputImageView.image= [rotatedImage resizeImageToWidth:432.f];
        }
    }
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
            [self openLibrary];
        }
    }
    else if(actionSheet.tag == 200 && buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0) {
            
            CameraView *cameraView = [[CameraView alloc] initWithFrame:self.view.bounds completionBlovk:^(UIImage *img) {
                
                NSLog(@"%@",NSStringFromCGSize(img.size));
                inputImageView.image = [img resizeImageToWidth:432];
            }];
            
            [cameraView.layer setOpacity:0];
            
            [UIView animateWithDuration:.25 animations:^{
                [cameraView.layer setOpacity:1.0];
            }];
             
            [self.view addSubview:cameraView];
        }
        else if (buttonIndex == 1) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if (buttonIndex == 2) {
            [self openLibrary];
        }

    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < photos.count) {
        return photos[index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    if (index < photos.count) {
        return photos[index];
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
    MWPhoto * photo = photos [index];
    [inputImageView setImage:photo.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private method

- (NSString*)filePath:(NSString*)name {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingFormat:@"/%@.jpg",name];
    
    return filePath;
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
            if([strings.string lastObject])
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

#pragma mark - 

-(void) shareReportViaMail:(NSString *)reportPath{
    

    MFMailComposeViewController *composer =[MFMailComposeViewController new];
    [composer setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        [composer setToRecipients:@[]];
        [composer setSubject:@"Report - LNPR"];
        [composer setMessageBody:@"LNPR Report attached" isHTML:NO];
        NSData *data = [NSData dataWithContentsOfFile:reportPath];
        [composer addAttachmentData:data mimeType:@"application/pdf" fileName:@"Report"];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:nil];
    }
    else{
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alrt show];
        
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(error)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alrt show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
