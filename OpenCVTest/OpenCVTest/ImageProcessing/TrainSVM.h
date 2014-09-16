//
//  TrainSVM.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 16/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#ifndef __OpenCVTest__TrainSVM__
#define __OpenCVTest__TrainSVM__

using namespace std;
using namespace cv;

class TrainSVM {
    
private:
    int imageWidth;
    int imageHeight;
    int numberofPlates;
    int numberNotPlates;
public:

    TrainSVM();
    
    bool train(Mat img_gray);
    
};

#endif /* defined(__OpenCVTest__TrainSVM__) */
