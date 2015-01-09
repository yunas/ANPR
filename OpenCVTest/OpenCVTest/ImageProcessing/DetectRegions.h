//
//  DetectRegions.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 15/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//


#ifndef DetectRegions_h
#define DetectRegions_h

#include <string.h>
#include <vector>

#include "Plate.h"

using namespace std;
using namespace cv;

class DetectRegions{

public:
    DetectRegions();
    string filename;
    
    float aspectRatio;
    float minArea;
    float maxArea;
    float error;
    void setFilename(string f);
    bool saveRegions;
    bool showSteps;
    vector<Plate> run(cv::Mat input);

    vector<Plate> drawRegion(Mat input);
    Mat testingDrawRegion(Mat input);
    Mat regionProcessing(Mat input);
    Mat grayImage(Mat sourceImage);
    double preProcessingangle( cv::Point pt1, cv::Point pt2, cv::Point pt0 );
    Mat enhanceContrast(Mat input);
    Mat enhanceSharpness(Mat input);
    
    
    Mat getGrayScaleMat(Mat source);
    Mat getSobelFilteredMat(Mat source);
    Mat getBlurMat(Mat source);
    Mat getThresholdMat(Mat source);
    Mat getMorpholgyMat(Mat source);
    vector<RotatedRect> getPossibleRegionsAfterFindContour(Mat source);
    Mat getFloodFillMask(Mat input, Mat output, RotatedRect rect);
    RotatedRect getDetectedPlateRectFromMask(Mat source);
    Mat getRotated2by3MatFromDetectedRectangle(RotatedRect source);
    Mat rotateImageMat(Mat source, Mat rotmat);
    Mat getCroppedMat(Mat source, RotatedRect rect);
    Mat getResizedMat(Mat source, cv::Size size);
    Mat getNormalisedGrayscaleMat(Mat source);
    Mat histogramEqualizedMat(Mat source);

    Mat edgeDetectionCanny(Mat input);
    Mat sharpImage(Mat source);
    
    Mat filterMedianSmoot(const Mat &source);
    
private:
    vector<Plate> segment(Mat input);
    bool verifySizes(RotatedRect mr);
    Mat histeq(Mat in);
    Mat blurImage(Mat input);
    Mat imageMorphology(Mat input);
    
#pragma mark - New testing methods.
    
    vector<Plate> segment5(Mat input);
    Mat LPRalgorithm(Mat src_img);
    Mat preProcessing(Mat src_img);
};

#endif
