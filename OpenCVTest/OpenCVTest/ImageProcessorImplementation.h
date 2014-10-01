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

+ (UIImage *)getLocalisedImageFromSource:(UIImage*)src imageName:(NSString*)name;
+ (UIImage *)harissCornerDetector:(UIImage*)source;
+ (UIImage *)ShiTomasiCornerDetector:(UIImage*)source;

- (UIImage*)LocalizeImageFromSource:(UIImage *)image;

- (UIImage*)dilationOfSource:(UIImage *)src;
- (UIImage*)erosionOfSource:(UIImage *)src;

+ (BOOL)trainSVM;

+ (UIImage*)getGrayScaleImage:(UIImage*)source;
+ (UIImage*)getSobelFilteredImage:(UIImage*)source;
+ (UIImage*)getBlurImage:(UIImage*)source;
+ (UIImage*)getThresholdImage:(UIImage*)source;
+ (UIImage*)getMorpholgyImage:(UIImage*)source;
+ (NSArray*)getPossibleRegionsAfterFindContour:(UIImage*)source;
+ (CGRect)getDetectedPlateRect:(UIImage*)source;
+ (UIImage*)getRotatedImage:(UIImage*)source;
+ (UIImage*)getCroppedImage:(UIImage*)source frame:(CGRect)rect;
+ (UIImage*)getResizedImage:(UIImage*)source size:(CGSize)size;
+ (UIImage*)getNormalisedGrayscaleImage:(UIImage*)source;
+ (UIImage*)histogramEqualizedImage:(UIImage*)source;

@end
