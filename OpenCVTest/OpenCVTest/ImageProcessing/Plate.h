/*****************************************************************************
*   Number Plate Recognition using SVM and Neural Networks
******************************************************************************
*   by David Millán Escrivá, 5th Dec 2012
*   http://blog.damiles.com
******************************************************************************
*   Ch5 of the book "Mastering OpenCV with Practical Computer Vision Projects"
*   Copyright Packt Publishing 2012.
*   http://www.packtpub.com/cool-projects-with-opencv/book
*****************************************************************************/

#ifndef Plate_h
#define Plate_h

#include <string.h>
#include <vector>

using namespace std;
using namespace cv;

class Plate{
    public:
        Plate();
        Plate(cv::Mat img, cv::Rect pos);
        string str();
        cv::Rect position;
        cv::Mat plateImg;
        vector<char> chars;
        vector<cv::Rect> charsPos;
};

#endif
