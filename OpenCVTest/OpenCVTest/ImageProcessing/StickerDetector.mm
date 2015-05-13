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
    img_removedCircles =[StickerDetector removeStickerColoredRegionFromImage:img_removedCircles];
    UIImage *watchTestImg = nil;

//    img_removedCircles =[StickerDetector removeStickerColoredRegionFromImage:img_gray];
    OffsetImage(img_removedCircles, Scalar(255, 255, 255), 20, 20);
    watchTestImg = [UIImage imageWithCVMat:img_removedCircles];

    return img_removedCircles;
}

bool detectsmallerCirlce(Vec3f circle) {

    double y = circle[1];
    double r = circle[2];

    if ((y>10 && y<20) && (r>=11 && r<=13)) {
        return true;
    }
    return false;
}

bool detectlargererCirlce(Vec3f circle) {

    double y = circle[1];
    double r = circle[2];

    if ((y>43 && y<54) && (r>=13 && r<=15)) {
        return true;
    }
    return false;
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
    HoughCircles(img_gray, detectedCircles, CV_HOUGH_GRADIENT, 2.5, 5, 100,65,8, 17);

    //Filter the detected circles
    for (int i = 0; i< detectedCircles.size(); i++){
        Vec3f circle = detectedCircles[i];

        if ((circle[0] <= img_gray.cols*0.35) && (detectsmallerCirlce(circle) || detectlargererCirlce(circle))) {
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

    inpaint(img_gray, black, dest, 5 , cv::INPAINT_TELEA);

    watchTestImg = [UIImage imageWithCVMat:dest];

    return dest;
}

+ (void)blobDetection:(Mat)src {

    UIImage *watchTestImg = nil;
    watchTestImg = [UIImage imageWithCVMat:src];

    // Setup SimpleBlobDetector parameters.
    SimpleBlobDetector::Params params;

    // Change thresholds
    params.minThreshold = 10;
    params.maxThreshold = 200;

    // Filter by Area.
    params.filterByArea = true;
    params.minArea = 1500;

    // Filter by Circularity
    params.filterByCircularity = true;
    params.minCircularity = 0.1;

    // Filter by Convexity
    params.filterByConvexity = true;
    params.minConvexity = 0.87;

    // Filter by Inertia
    params.filterByInertia = true;
    params.minInertiaRatio = 0.01;

    // Storage for blobs
    vector<KeyPoint> keypoints;

#if CV_MAJOR_VERSION < 3   // If you are using OpenCV 2

    // Set up detector with params
    SimpleBlobDetector detector(params);

    // Detect blobs
    detector.detect( src, keypoints);
#else

    // Set up detector with params
    Ptr<SimpleBlobDetector> detector = SimpleBlobDetector::create(params);

    // Detect blobs
    detector->detect( src, keypoints);
#endif

    Mat im_with_keypoints;
    drawKeypoints( src, keypoints, im_with_keypoints, Scalar(0,0,255), DrawMatchesFlags::DRAW_RICH_KEYPOINTS );
    watchTestImg = [UIImage imageWithCVMat:src];
}

+ (cv::Mat)removeStickerColoredRegionFromImage:(cv::Mat)src {

    //Expecting a Gray Scale Image Mat
    cv::Mat img_gray= src.clone();

    UIImage *watchTestImg = nil;
    watchTestImg = [UIImage imageWithCVMat:img_gray];

    cv::Mat binaryMat;
    cv::Mat dest;
    
//    cv::Mat temp = cvCreateImage(img_gray.size(), 8, 1);
//    temp.setTo(Scalar(255),dest);

    inRange(img_gray, Scalar(0), Scalar(80), binaryMat);
    binaryMat = 255 - binaryMat;

    UIImage *image =[UIImage imageWithCVMat:binaryMat];


    cv::cvtColor(binaryMat, dest, CV_GRAY2BGR);
    image =[UIImage imageWithCVMat:dest];

//    Mat img_dst;
//    threshold(img_gray, img_dst, 60, 255, THRESH_BINARY);
//    UIImage *watchTest = [UIImage imageWithCVMat:img_dst];

    return dest;
}

void OffsetImage(Mat &image, cv::Scalar bordercolour, int xoffset, int yoffset)
{
    Mat temp(image.rows+2*yoffset,image.cols+2*xoffset,image.type(),bordercolour);
    Mat roi(temp(cvRect(xoffset,yoffset,image.cols,image.rows)));
    image.copyTo(roi);
    image=temp.clone();
}
@end
