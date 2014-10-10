//
//  CameraView.m
//  LNPR
//
//  Created by Muhammad Rashid on 10/10/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "CameraView.h"
#include "UIImage+operation.h"

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>


@interface CameraView () {
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureSession *session;
}
@end

@implementation CameraView {
    UIButton *cancelButton;
    UIButton *takePhotoButton;
    UIButton *switchButton;
    UIView *canvasView;
    BOOL frontCameraSelected;
}

- (instancetype)initWithFrame:(CGRect)frame completionBlovk:(CompletionBlock)blk {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        
        _block = [blk copy];
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"backFromCamera"] forState:UIControlStateNormal];
        [cancelButton setFrame:CGRectMake(10.f, 32.f, 30.f, 30.f)];
        [cancelButton addTarget:self action:@selector(hideCameraView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [switchButton setTintColor:[UIColor whiteColor]];
        [switchButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        [switchButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [switchButton setTitle:@"Front" forState:UIControlStateNormal];
        [switchButton setBackgroundColor:[UIColor colorWithRed:249.0/255 green:130.0/255 blue:30.0/255 alpha:1]];
        [switchButton setFrame:CGRectMake(CGRectGetWidth(frame)-60.f, CGRectGetMidY(cancelButton.frame)-15, 50.f, 30.f)];
        switchButton.layer.cornerRadius = 10.f;
        [switchButton addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchButton];
        
        CGRect imgFrame = CGRectMake(0, CGRectGetMaxY(cancelButton.frame)+10.f, CGRectGetWidth(frame), 250);
        canvasView = [[UIImageView alloc] initWithFrame:imgFrame];
        [canvasView setBackgroundColor:[UIColor redColor]];
        [self addSubview:canvasView];
        
        takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoButton setImage:[UIImage imageNamed:@"captureButton"] forState:UIControlStateNormal];
        [takePhotoButton setFrame:CGRectMake(0, CGRectGetMaxY(imgFrame)+20.f, 57.5, 30.f)];
        CGPoint center = CGPointMake(self.center.x, takePhotoButton.center.y);
        takePhotoButton.center = center;
        [takePhotoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:takePhotoButton];
        
        [self startSession];
    }
    
    return self;
}

#pragma mark AVFoundation

-(AVCaptureDevice *)frontFacingCameraIfAvailable {
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionFront) {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice hasFlash] && [captureDevice isFlashAvailable]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([captureDevice hasTorch] && [captureDevice isTorchAvailable]) {
            [captureDevice setTorchMode:AVCaptureTorchModeAuto];
        }
    }
    else {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    [captureDevice unlockForConfiguration];
    
    return captureDevice;
}

-(AVCaptureDevice *)backFacingCameraIfAvailable {
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice hasFlash] && [captureDevice isFlashAvailable]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([captureDevice hasTorch] && [captureDevice isTorchAvailable]) {
            [captureDevice setTorchMode:AVCaptureTorchModeAuto];
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
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    CGRect frame = canvasView.bounds;
    [canvasView.layer setMasksToBounds:YES];
    captureVideoPreviewLayer.frame = frame;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [canvasView.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [self backFacingCameraIfAvailable];
    
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not found. Please use Photo Gallery instead." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [session addInput:input];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG,
                                     (id)kCVPixelBufferWidthKey: @(432.f),
                                     (id)kCVPixelBufferHeightKey: @(302)};
    
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}

#pragma mark IBActions

- (void)hideCameraView:(UIButton*)sender {
    [self removeFromSuperview];
}

- (void)takePicture:(UIButton*)sender {
    
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
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    
    // Update the orientation on the still image output video connection before capturing.
    [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];

         UIImage *rotatedImage = nil;
         
         if (image.imageOrientation!=UIImageOrientationUp)
             rotatedImage = [image rotate:image.imageOrientation];
         else
             rotatedImage = image;
         
         UIImage *photoImage = [rotatedImage copy];
         
         CGRect refRect = canvasView.frame; //Define this to the exact frame which you want to crop the larger image to i.e. with smaller frame.size.height
         CGFloat deviceScale = photoImage.scale;
         CGImageRef imageRef = CGImageCreateWithImageInRect(photoImage.CGImage, refRect);
         
         UIImage *finalPhoto = [[UIImage alloc] initWithCGImage:imageRef scale:deviceScale orientation:photoImage.imageOrientation];
         
         _block(rotatedImage);
         
         [self hideCameraView:sender];
         
     }];
}

- (void)switchCamera:(UIButton*)sender {
    
    AVCaptureDevice *device = nil;
    
    if (frontCameraSelected) {
        device = [self backFacingCameraIfAvailable];
        frontCameraSelected = NO;
    }
    else {
        device = [self frontFacingCameraIfAvailable];
        frontCameraSelected = YES;
    }

    [switchButton setTitle:(frontCameraSelected)?@"Back":@"Front" forState:UIControlStateNormal];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not found. Please use Photo Gallery instead." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    NSArray *inputs = session.inputs;
    
    for (AVCaptureDeviceInput *inpt in inputs) {
        [session removeInput:inpt];
    }
    
    [session addInput:input];
}

#pragma - mark Getters

- (CGRect)canvasFrame {
    return canvasView.frame;
}

@end
