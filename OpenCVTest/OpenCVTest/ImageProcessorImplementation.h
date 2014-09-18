//
//  ImageProcessor.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 08/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageProcessingDone)(UIImage *image);

@interface ImageProcessorImplementation : NSObject
{
    ImageProcessingDone completionBlock;
}

+ (void)getLocalisedImageFromSource:(UIImage*)src imageName:(NSString*)name result:(ImageProcessingDone)block;
+ (UIImage *)harissCornerDetector:(UIImage*)source;
+ (UIImage *)ShiTomasiCornerDetector:(UIImage*)source;

- (UIImage*)LocalizeImageFromSource:(UIImage *)image;

- (UIImage*)dilationOfSource:(UIImage *)src;
- (UIImage*)erosionOfSource:(UIImage *)src;

+ (BOOL)trainSVM;

@end
