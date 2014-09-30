//
//  ImageProcessor.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 08/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#ifndef __OpenCVTest__ImageProcessor__
#define __OpenCVTest__ImageProcessor__

#include <iostream>

class ImageProcessor {
    typedef struct{
        int contador;
        double media;
    } cuadrante;
    
public:
    cv::Mat processImage(cv::Mat source, float height);
    cv::Mat filterMedianSmoot(const cv::Mat &source);
    cv::Mat filterGaussian(const cv::Mat&source);
    cv::Mat equalize(const cv::Mat&source);
    cv::Mat binarize(const cv::Mat&source);
    int correctRotation (cv::Mat &image, cv::Mat &output, float height);
    cv::Mat rotateImage(const cv::Mat& source, double angle);
};


#endif /* defined(__OpenCVTest__ImageProcessor__) */
