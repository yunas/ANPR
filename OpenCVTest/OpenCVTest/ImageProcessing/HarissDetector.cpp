//
//  HarissDetector.cpp
//  OpenCVTest
//
//  Created by Muhammad Rashid on 15/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#include "HarissDetector.h"

HarissDetector::HarissDetector() {
    /// Detector parameters
    blockSize = 2;
    apertureSize = 3;
    k = 0.04;
    thresh = 100;
}

Mat HarissDetector::cornerHarris_demo(Mat input) {
    
    Mat img_gray;
    
    if (input.channels() == 3)
        cv::cvtColor(input, img_gray, COLOR_BGR2GRAY);
    else if (input.channels() == 4) {
        Mat temp;
        cv::cvtColor(input, temp, COLOR_BGRA2BGR);
        cv::cvtColor(input, img_gray, COLOR_BGRA2GRAY);
        temp.copyTo(input);
    }
    else if(input.channels() == 1)
        img_gray = input;
    
    Mat dst, dst_norm, dst_norm_scaled;
    dst = Mat::zeros( input.size(), CV_32FC1 );
    
    /// Detecting corners
    cornerHarris( img_gray, dst, blockSize, apertureSize, k, BORDER_DEFAULT );
    
    /// Normalizing
    normalize( dst, dst_norm, 0, 255, NORM_MINMAX, CV_32FC1, Mat() );
    convertScaleAbs( dst_norm, dst_norm_scaled );
    
//    RotatedRect minRect = minAreaRect(dst_norm_scaled);
    
    /// Drawing a circle around corners
    for( int j = 0; j < dst_norm.rows ; j++ ) {
        for( int i = 0; i < dst_norm.cols; i++ ) {

            if( (int) dst_norm.at<float>(j,i) > thresh ) {
            circle( dst_norm_scaled, Point( i, j ), 5,  Scalar(0), 2, 8, 0 );
            }
        }
    }
    
    return dst_norm_scaled;
}

Mat HarissDetector::goodFeaturesToTrack_Demo(Mat input) {
    
    int maxCorners = 23;
    RNG rng(12345);
    
    Mat img_gray;
    
    if (input.channels() == 3)
        cv::cvtColor(input, img_gray, COLOR_BGR2GRAY);
    else if (input.channels() == 4) {
        Mat temp;
        cv::cvtColor(input, temp, COLOR_BGRA2BGR);
        cv::cvtColor(input, img_gray, COLOR_BGRA2GRAY);
        temp.copyTo(input);
    }
    else if(input.channels() == 1)
        img_gray = input;
    
    /// Parameters for Shi-Tomasi algorithm
    vector<Point2f> corners;
    double qualityLevel = 0.01;
    double minDistance = 10;
    int blockSize1 = 3;
    bool useHarrisDetector = false;
    double k1 = 0.04;
    
    /// Copy the source image
    Mat output;
    output = input.clone();
    
    /// Apply corner detection
    goodFeaturesToTrack( img_gray,
                        corners,
                        maxCorners,
                        qualityLevel,
                        minDistance,
                        Mat(),
                        blockSize1,
                        useHarrisDetector,
                        k1 );
    
    // Draw corners detected
    cout<<"** Number of corners detected: "<<corners.size()<<endl;
    int r = 4;
    for( int i = 0; i < corners.size(); i++ )
    { circle( output, corners[i], r, Scalar(rng.uniform(0,255), rng.uniform(0,255),
                                          rng.uniform(0,255)), -1, 8, 0 ); }

    return output;
}