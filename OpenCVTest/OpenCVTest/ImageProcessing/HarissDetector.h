//
//  HarissDetector.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 15/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#ifndef __OpenCVTest__HarissDetector__
#define __OpenCVTest__HarissDetector__

#include <iostream>

#include <string.h>
#include <vector>

using namespace std;
using namespace cv;

class HarissDetector {
    
private:
    /// Detector parameters
    int blockSize;
    int apertureSize;
    double k;
    int thresh;
    
public:
    HarissDetector();
    Mat cornerHarris_demo(Mat input);
    Mat goodFeaturesToTrack_Demo(Mat input);
};


#endif
