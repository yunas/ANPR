//
//  ImageProcessor.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 08/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ImageProcessorImplementation.h"
#import "UIImage+OpenCV.h"
#include "DetectRegions.h"
#import "StickerDetector.h"

using namespace std;

@interface ImageProcessorImplementation ()
RotatedRect getOnePossiblePlateRegion(vector<RotatedRect> rects, float error);
@end

@implementation ImageProcessorImplementation



#pragma mark - EDGE DETECTION

+ (UIImage*)numberPlateFromWithSobelCarImage:(UIImage*)image imageName:(NSString *)name {
    
    // Algo
    // 1. pre processing => image to gray scale
    // 2. Apply Gaussian Blur of 5x5
    // 3. Apply Sobel filter
    // 4. Apply threshold and morphological operation
    // 5. Apply Contours to fetch Possible Regions

    // input image
    cv::Mat input_img = [image CVMat];
    vector<Plate> posible_regions;
    
    DetectRegions detectRegions;
    detectRegions.setFilename("12");
    detectRegions.saveRegions = YES;
    detectRegions.showSteps = false;

    UIImage *watchTestImg = nil;
    
    // pre processing => image to gray scale
    cv::Mat img_gray = detectRegions.getGrayScaleMat(input_img);
    
    watchTestImg = [UIImage imageWithCVMat:img_gray];
    
    if (input_img.channels()==4) {
        
        Mat temp;
        cv::cvtColor(input_img, temp, COLOR_BGRA2BGR);
        temp.copyTo(input_img);
    }
    
    // apply gaussian blur of 5x5
    Mat img_blur = detectRegions.getBlurMat(img_gray);
    watchTestImg = [UIImage imageWithCVMat:img_blur];
    
    //Finde vertical lines. Car plates have high density of vertical lines
    Mat img_sobel;
    img_sobel = detectRegions.getSobelFilteredMat(img_blur);
    watchTestImg = [UIImage imageWithCVMat:img_sobel];
    
    //threshold image & Morphplogic operation close
    Mat img_threshold;
    img_threshold = detectRegions.getMorpholgyMat(img_sobel);
    watchTestImg = [UIImage imageWithCVMat:img_threshold];
    
    //Find contours of possibles plates
    vector<RotatedRect> rects;
    rects = detectRegions.getPossibleRegionsAfterFindContour(img_threshold);
    
    cout<<"number of possible regions:"<<rects.size()<<endl;

    // for flood fill
    cv::Mat result;
    input_img.copyTo(result);
    
    
    for(int i=0; i< rects.size(); i++) {
        
        Mat mask;
        mask = detectRegions.getFloodFillMask(input_img, result, rects[i]);

        watchTestImg = [UIImage imageWithCVMat:mask];
        
        RotatedRect minRect = detectRegions.getDetectedPlateRectFromMask(mask);

        if(verifySizes(minRect,0.4)) {
            
            // rotated rectangle drawing
            Point2f rect_points[4]; minRect.points( rect_points );
            for( int j = 0; j < 4; j++ )
                line( result, rect_points[j], rect_points[(j+1)%4], Scalar(0,0,255), 1, 8 );
            
            //Get rotation matrix
            Mat rotmat = detectRegions.getRotated2by3MatFromDetectedRectangle(minRect);
            
            //Create and rotate image
            Mat img_rotated;
            img_rotated = detectRegions.rotateImageMat(input_img, rotmat);
            watchTestImg = [UIImage imageWithCVMat:img_rotated];
            
//            minRect.size.width +=2.5;
//            minRect.size.height +=10;

            //Crop image
            Mat img_crop;
            img_crop = detectRegions.getCroppedMat(img_rotated, minRect);
            watchTestImg = [UIImage imageWithCVMat:img_crop];

            Mat img_stickerRemoved;
            img_stickerRemoved = [StickerDetector removeStickerFromPlate:watchTestImg];
            watchTestImg = [UIImage imageWithCVMat:img_stickerRemoved];

            Mat img_resized;
            img_resized = detectRegions.getResizedMat(img_stickerRemoved, cv::Size(300,70));
            watchTestImg = [UIImage imageWithCVMat:img_resized];

            //Equalize croped image
            Mat img_grayResult = img_resized.clone();
//            img_grayResult = detectRegions.getNormalisedGrayscaleMat(img_resized);
//            watchTestImg = [UIImage imageWithCVMat:img_grayResult];

            posible_regions.push_back(Plate(img_grayResult,minRect.boundingRect()));

//            Mat img_contrast = detectRegions.enhanceContrast(img_grayResult);
//          posible_regions.push_back(Plate(img_contrast,minRect.boundingRect()));
//            watchTestImg = [UIImage imageWithCVMat:img_contrast];
//
//            //12/17/2014 new addition
//            Mat img_sharp = detectRegions.sharpImage(img_grayResult);
//            watchTestImg = [UIImage imageWithCVMat:img_sharp];

            //12/11/2014
//            cv::Mat blackNWhiteMat = [watchTestImg CVMat];
//            blackNWhiteMat = detectRegions.getGrayScaleMat(blackNWhiteMat);
//            img_contrast = detectRegions.getThresholdMat(blackNWhiteMat);
//            posible_regions.push_back(Plate(img_sharp,minRect.boundingRect()));

//            Mat contrast_image = detectRegions.enhanceContrast(img_resized);
//            posible_regions.push_back(Plate(contrast_image,minRect.boundingRect()));
        }
    }
    
    cout<<"detected plate regions:"<<posible_regions.size()<<endl;

    UIImage *outImage = nil;
    NSData *data = nil;
    NSString* filePath = nil;
    
    for (int i=0; i<posible_regions.size(); i++) {
        
        Plate rect = posible_regions[i];
        
        outImage = [UIImage imageWithCVMat:rect.plateImg];
        
        data = UIImageJPEGRepresentation(outImage, 1);
        filePath = [ImageProcessorImplementation filePath:[NSString stringWithFormat:@"detected_%@_%d",name,i]];
        [data writeToFile:filePath atomically:YES];
    }

    return outImage;
}

+ (UIImage*)numberPlateWithCannyFromCarImage:(UIImage*)image imageName:(NSString *)name {
    
    // Algo
    // 1. pre processing => image to gray scale
    // 2. Apply Gaussian Blur of 5x5
    // 3. Apply Canny filter
    // 4. Apply threshold and morphological operation
    // 5. Apply Contours to fetch Possible Regions
    
    // input image
    cv::Mat input_img = [image CVMat];
    vector<Plate> posible_regions;
    
    DetectRegions detectRegions;
    detectRegions.setFilename("canny");
    detectRegions.saveRegions = YES;
    detectRegions.showSteps = false;
    
    UIImage *watchTestImg = nil;
    
    // pre processing => image to gray scale
    cv::Mat img_gray = detectRegions.getGrayScaleMat(input_img);
    
    watchTestImg = [UIImage imageWithCVMat:img_gray];
    
    if (input_img.channels()==4) {
        
        Mat temp;
        cv::cvtColor(input_img, temp, COLOR_BGRA2BGR);
        temp.copyTo(input_img);
    }
    
    // apply gaussian blur of 5x5
    Mat img_blur = detectRegions.getBlurMat(img_gray);
    watchTestImg = [UIImage imageWithCVMat:img_blur];
    
    Mat img_canny = detectRegions.edgeDetectionCanny(img_blur);
    watchTestImg = [UIImage imageWithCVMat:img_canny];
    
    //threshold image & Morphplogic operation close
    Mat img_threshold;
    img_threshold = detectRegions.getThresholdMat(img_canny);
    watchTestImg = [UIImage imageWithCVMat:img_threshold];
    
    //Find contours of possibles plates
    vector<RotatedRect> rects;
    rects = detectRegions.getPossibleRegionsAfterFindContour(img_threshold);
    
    cout<<"number of possible regions:"<<rects.size()<<endl;
    
    // for flood fill
    cv::Mat result;
    input_img.copyTo(result);
    
    for(int i=0; i< rects.size(); i++) {
        
        Mat mask;
        mask = detectRegions.getFloodFillMask(input_img, result, rects[i]);
        watchTestImg = [UIImage imageWithCVMat:mask];
        
        RotatedRect minRect = detectRegions.getDetectedPlateRectFromMask(mask);
        
        cv::Rect rect = minRect.boundingRect();
        
        if(verifySizes(minRect,0.4) && !(rect.x==0 || rect.y==0)) {
            
            //Get rotation matrix
            Mat rotmat = detectRegions.getRotated2by3MatFromDetectedRectangle(minRect);
            
            //Create and rotate image
            Mat img_rotated;
            img_rotated = detectRegions.rotateImageMat(input_img, rotmat);
            watchTestImg = [UIImage imageWithCVMat:img_rotated];
            
            //Crop image
            Mat img_crop;
            img_crop = detectRegions.getCroppedMat(img_rotated, minRect);
            watchTestImg = [UIImage imageWithCVMat:img_crop];
            
            //Resize image to (300,69)
            Mat img_resized;
            img_resized = detectRegions.getResizedMat(img_crop, cv::Size(300,69));
            watchTestImg = [UIImage imageWithCVMat:img_resized];
            
            //Equalize croped image
            Mat img_grayResult;
            img_grayResult = detectRegions.getNormalisedGrayscaleMat(img_resized);
            watchTestImg = [UIImage imageWithCVMat:img_grayResult];
            
            img_grayResult = detectRegions.getThresholdMat(img_grayResult);
            watchTestImg = [UIImage imageWithCVMat:img_grayResult];
            
            Mat img_contrast = detectRegions.enhanceContrast(img_resized);
            watchTestImg = [UIImage imageWithCVMat:img_contrast];
            
            Mat img_correction;
            img_correction = detectRegions.getGrayScaleMat(img_contrast);
            img_correction = detectRegions.getThresholdMat(img_correction);
            watchTestImg = [UIImage imageWithCVMat:img_correction];
            
            posible_regions.push_back(Plate(img_correction,minRect.boundingRect()));
        }
    }
    
    cout<<"number of detected plate:"<<posible_regions.size()<<endl;
    
    UIImage *outImage = nil;
    NSData *data = nil;
    NSString* filePath = nil;
    
    for (int i=0; i<posible_regions.size(); i++) {
        
        Plate rect = posible_regions[i];
        
        outImage = [UIImage imageWithCVMat:rect.plateImg];
        
        data = UIImageJPEGRepresentation(outImage, 1);
        filePath = [ImageProcessorImplementation filePath:[NSString stringWithFormat:@"detected_%@_%d",name,i]];
        [data writeToFile:filePath atomically:YES];
    }
    
    return outImage;
}

+ (UIImage *)numberPlateFromCarImage:(UIImage*)src imageName:(NSString*)name edgeDetectionType:(EdgeDetectionType)type {
    
    UIImage *outImg = nil;
    
    if (type == EdgeDetectionTypeSobel) {
        outImg = [ImageProcessorImplementation numberPlateFromWithSobelCarImage:src imageName:name];
    }
    else if (type == EdgeDetectionTypeCanny) {
        outImg = [ImageProcessorImplementation numberPlateWithCannyFromCarImage:src imageName:name];
    }
    return outImg;
}


#pragma  mark getter methods (Debug)

+ (UIImage*)contrastImage:(UIImage*)image contrast:(float)contrast {
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIColorControls"];
    [brightnesContrastFilter setDefaults];
    [brightnesContrastFilter setValue:inputImage forKey:kCIInputImageKey];
    [brightnesContrastFilter setValue:[NSNumber numberWithFloat:contrast]
                               forKey:@"inputContrast"];
    // Get the output image recipe
    CIImage *outputImage = [brightnesContrastFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    return [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
}

+ (UIImage*)getGrayScaleImage:(UIImage*)source {
    
    Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getGrayScaleMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}

+ (UIImage*)getSobelFilteredImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getSobelFilteredMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}

+ (UIImage*)getBlurImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getBlurMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
    
}

+ (UIImage*)getThresholdImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getThresholdMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
    
}

+ (UIImage*)getMorpholgyImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getMorpholgyMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
    
}

+ (NSArray*)getPossibleRegionsAfterFindContour:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    vector<RotatedRect> output_images = detectRegions.getPossibleRegionsAfterFindContour(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:input_image];
    return @[outImage];
}
+ (CGRect)getDetectedPlateRect:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    RotatedRect rotatedRect = detectRegions.getDetectedPlateRectFromMask(input_image);
    
    cv::Rect boundingRect = rotatedRect.boundingRect();
    Size2f size = rotatedRect.size;
    
    CGRect rect  = CGRectMake(boundingRect.x, boundingRect.y, size.width, size.height);
    
    return rect;
}
+ (UIImage*)getRotatedImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.rotateImageMat(input_image, Mat(input_image.size(), input_image.type()));
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}
+ (UIImage*)getCroppedImage:(UIImage*)source frame:(CGRect)frame{
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    
    Point2f point = cv::Point(CGRectGetMinX(frame), CGRectGetMinY(frame));
    Size2f size = cv::Size(CGRectGetWidth(frame), CGRectGetHeight(frame));
    RotatedRect rect = RotatedRect(point, size, 0);
    
    Mat output_image = detectRegions.getCroppedMat(input_image, rect);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}
+ (UIImage*)getResizedImage:(UIImage*)source size:(CGSize)size {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getResizedMat(input_image, cv::Size(size.width,size.height));
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}
+ (UIImage*)getNormalisedGrayscaleImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.getNormalisedGrayscaleMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}
+ (UIImage*)histogramEqualizedImage:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    DetectRegions detectRegions;
    Mat output_image = detectRegions.histogramEqualizedMat(input_image);
    
    UIImage *outImage = [UIImage imageWithCVMat:output_image];
    return outImage;
}

#pragma mark - instance methods

+ (NSString*)filePath:(NSString*)name {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingFormat:@"/l%@.jpg",name];
    
    return filePath;
}

+ (cv::Mat)grayImage:(cv::Mat)sourceImage {
    
    cv::Mat gray;
    if (sourceImage.channels() == 3)
        cv::cvtColor(sourceImage, gray, cv::COLOR_BGR2GRAY);
    else if (sourceImage.channels() == 4)
        cv::cvtColor(sourceImage, gray, cv::COLOR_BGRA2GRAY);
    else if(sourceImage.channels() == 1)
        gray = sourceImage;
    
    return gray;
}

RotatedRect getOnePossiblePlateRegion(vector<RotatedRect> rects, float error) {
    
    vector<RotatedRect>newRects;
    RotatedRect rect;
    
    for (int i=0; i<rects.size(); i++) {
        
        RotatedRect mr = rects[i];
        
        if(verifySizes(mr,error)){
            newRects.push_back(mr);
            rect = mr;
        }
    }
    
    if (newRects.size()>1) {
       return getOnePossiblePlateRegion(newRects,(error-0.05));
    }
    else if (newRects.size()==0) {
        return RotatedRect(cv::Point(0,0), cv::Size(0,0), 0);
    }
    else {
        return newRects[0];
    }
}

bool verifySizes(cv::RotatedRect mr, float error){
    
    //German car plate size: 520x112 aspect 4.6429
    float aspect=4.6429;
    //Set a min and max area. All other patchs are discarded
    int min= 15*aspect*15; // minimum area
    int max= 125*aspect*125; // maximum area
    //Get only patchs that match to a respect ratio.
    float rmin= aspect-aspect*error;
    float rmax= aspect+aspect*error;
    
    if (!((mr.angle >= -91 && mr.angle <= -85) || (mr.angle >= -2.0 && mr.angle <= -0.0 ))) {
        return false;
    }
    
    int area= mr.size.height * mr.size.width;
    float r= (float)mr.size.width / (float)mr.size.height;
    if(r<1)
        r= (float)mr.size.height / (float)mr.size.width;
    
    if(( area < min || area > max ) || ( r < rmin || r > rmax )){
        return false;
    }else{
        return true;
    }
}

@end
