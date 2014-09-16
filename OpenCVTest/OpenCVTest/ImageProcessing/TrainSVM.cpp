//
//  TrainSVM.cpp
//  OpenCVTest
//
//  Created by Muhammad Rashid on 16/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#include "TrainSVM.h"

TrainSVM::TrainSVM() {
    imageHeight = 144;
    imageWidth = 33;
    numberofPlates = 49;
    numberNotPlates = 30;
}

bool TrainSVM::train(Mat img_gray) {
    
    cv::Mat classes;
    cv::Mat trainingData;
    
    cv::Mat trainingImages;
    std::vector<int> trainingLabels;
    
    for (int i = 1; i< numberofPlates; i++) {
  
    }
    
    img_gray= img_gray.reshape(1, 1);
    trainingImages.push_back(img_gray);
    trainingLabels.push_back(0);
    
    return true;
}