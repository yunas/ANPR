//
//  Sticker.m
//  LNPR
//
//  Created by Muhammad Rashid on 04/05/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import "StickerDetector.h"
#import "UIImage+OpenCV.h"
#include "DetectRegions.h"


@implementation StickerDetector

#pragma mark - REMOVE STICKER

+(cv::Mat) removeStickerFromPlate:(UIImage*)plateImg {

    cv::Mat input_img = [plateImg CVMat];
    DetectRegions detectRegions;
    detectRegions.setFilename("12");
    detectRegions.saveRegions = YES;
    detectRegions.showSteps = false;

    // pre processing => image to gray scale
    cv::Mat img_gray = detectRegions.getGrayScaleMat(input_img);

    cv::Mat img_removedCircles = [StickerDetector removeStickerCirclesFromImage:img_gray];
    return [StickerDetector removeStickerColoredRegionFromImage:img_removedCircles];
}

+(cv::Mat) removeStickerCirclesFromImage:(cv::Mat) src{

    //Expecting a grayScale Image
    //Refrence(s):
    //http://txt.arboreus.com/2014/10/21/remove-circles-from-an-image-in-python.html
    //http://stackoverflow.com/questions/11276390/houghcircles-parameters-to-recognise-balls
    //http://stackoverflow.com/questions/22930605/remove-circles-using-opencv

    cv::Mat dest;
    std::vector<cv::Vec3f> circles;
    std::vector<cv::Vec3f> detectedCircles;

    cv::Mat img_gray = src.clone();

    //Detect Cicles from Image and store them in destination variable
    HoughCircles(img_gray, detectedCircles, CV_HOUGH_GRADIENT, 2.5, 5, 100,85,8, 20);

    //Filter the detected circles
    for (int i = 0; i< detectedCircles.size(); i++){

        if (!(detectedCircles[i][0] > img_gray.cols*0.35)) {
            circles.push_back(detectedCircles[i]);
        }
    }

    UIImage *watchTestImg = [UIImage imageWithCVMat:img_gray];

    Mat black = Mat::zeros(img_gray.size(), img_gray.type());

    for (int i = 0; i< circles.size(); i++){

        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);

        cv::circle(black,center,radius,cv::Scalar(255),-1);
    }

    watchTestImg = [UIImage imageWithCVMat:black];

    inpaint(img_gray, black, dest, 17 , cv::INPAINT_TELEA);

    watchTestImg = [UIImage imageWithCVMat:dest];

    return dest;
}

+ (cv::Mat)removeStickerColoredRegionFromImage:(cv::Mat)src {

    //Expecting a Gray Scale Image Mat
    cv::Mat img_gray= src.clone();

    UIImage *watchTestImg = nil;

    watchTestImg = [UIImage imageWithCVMat:img_gray];

    cv::Mat binaryMat;
    cv::Mat dest;
    
    cv::Mat temp = cvCreateImage(img_gray.size(), 8, 1);

    inRange(img_gray, Scalar(0), Scalar(60), binaryMat);

    binaryMat = 255 - binaryMat;

    UIImage *image =[UIImage imageWithCVMat:binaryMat];

    temp.setTo(Scalar(255),dest);
    cv::cvtColor(binaryMat, dest, CV_GRAY2BGR);
    image =[UIImage imageWithCVMat:dest];

//    Mat img_dst;
//    threshold(img_gray, img_dst, 60, 255, THRESH_BINARY);
//    UIImage *watchTest = [UIImage imageWithCVMat:img_dst];

    return dest;
}

@end
