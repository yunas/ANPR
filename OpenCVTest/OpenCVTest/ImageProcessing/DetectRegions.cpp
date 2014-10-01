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

#include "DetectRegions.h"

void DetectRegions::setFilename(string s) {
        filename=s;
}

DetectRegions::DetectRegions(){
    showSteps=false;
    saveRegions=false;
    aspectRatio = 4.6429;
    minArea = 25;
    maxArea = 150;
}

bool DetectRegions::verifySizes(RotatedRect mr) {

    float error=0.4;
    //Spain car plate size: 520x112 aspect 4.6429
    float aspect=aspectRatio;
    //Set a min and max area. All other patchs are discarded
    int min= minArea*aspect*minArea; // minimum area
    int max= maxArea*aspect*maxArea; // maximum area
    //Get only patchs that match to a respect ratio.
    float rmin= aspect-aspect*error;
    float rmax= aspect+aspect*error;

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

Mat DetectRegions::histeq(Mat in) {
    Mat out(in.size(), in.type());
    if(in.channels()==3){
        Mat hsv;
        vector<Mat> hsvSplit;
        cv::cvtColor(in, hsv, COLOR_BGR2GRAY);
        split(hsv, hsvSplit);
        equalizeHist(hsvSplit[2], hsvSplit[2]);
        merge(hsvSplit, hsv);
        cvtColor(hsv, out, COLOR_HSV2BGR);
    }else if(in.channels()==1){
        equalizeHist(in, out);
    }

    return out;

}

vector<Plate> DetectRegions::segment(Mat input) {
    
    vector<Plate> output;

    //convert image to gray
    Mat img_gray;
    
    if (input.channels() == 3)
        cv::cvtColor(input, img_gray, COLOR_BGR2GRAY);
    else if (input.channels() == 4) {
        cv::cvtColor(input, img_gray, COLOR_BGRA2GRAY);
        Mat temp;
        cv::cvtColor(input, temp, COLOR_BGRA2BGR);
        temp.copyTo(input);
    }
    else if(input.channels() == 1)
        img_gray = input;
    
    Mat img_blur;
    img_blur = getBlurMat(img_gray);
    
    //Finde vertical lines. Car plates have high density of vertical lines
    Mat img_sobel;
    img_sobel = getSobelFilteredMat(img_blur);
    
    //threshold image & Morphplogic operation close
    Mat img_threshold;
    img_threshold = getMorpholgyMat(img_sobel);
    
    //Find contours of possibles plates
    vector< vector< Point> > contours;
    findContours(img_threshold,
            contours, // a vector of contours
            RETR_EXTERNAL, // retrieve the external contours
            CHAIN_APPROX_NONE); // all pixels of each contours

    //Start to iterate to each contour founded
    vector<vector<Point> >::iterator itc= contours.begin();
    vector<RotatedRect> rects;

    //Remove patch that are no inside limits of aspect ratio and area.    
    while (itc!=contours.end()) {
        //Create bounding rect of object
        RotatedRect mr= minAreaRect(Mat(*itc));
        if( !verifySizes(mr)){
            itc= contours.erase(itc);
        }else{
            ++itc;
            rects.push_back(mr);
        }
    }

    cout<<"number of possible regions:"<<rects.size()<<endl;
    
    // Draw blue contours on a white image
    cv::Mat result;
    input.copyTo(result);
    cv::drawContours(result,contours,
            -1, // draw all contours
            cv::Scalar(255,0,0), // in blue
            1); // with a thickness of 1

    for(int i=0; i< rects.size(); i++){

        //For better rect cropping for each posible box
        //Make floodfill algorithm because the plate has white background
        //And then we can retrieve more clearly the contour box
        circle(result, rects[i].center, 3, Scalar(0,255,0), -1);
        //get the min size between width and height
        float minSize=(rects[i].size.width < rects[i].size.height)?rects[i].size.width:rects[i].size.height;
        minSize=minSize-minSize*0.5;
        //initialize rand and get 5 points around center for floodfill algorithm
        srand ( time(NULL) );
        //Initialize floodfill parameters and variables
        Mat mask;
        mask.create(input.rows + 2, input.cols + 2, CV_8UC1);
        mask= Scalar::all(0);
        int loDiff = 30;
        int upDiff = 30;
        int connectivity = 4;
        int newMaskVal = 255;
        int NumSeeds = 20;
        Rect ccomp;
        int flags = connectivity + (newMaskVal << 8 ) + FLOODFILL_FIXED_RANGE + FLOODFILL_MASK_ONLY;
        for(int j=0; j<NumSeeds; j++){
            Point seed;
            seed.x=rects[i].center.x+rand()%(int)minSize-(minSize/2);
            seed.y=rects[i].center.y+rand()%(int)minSize-(minSize/2);
            circle(result, seed, 1, Scalar(0,255,255), -1);
            
            floodFill(input, mask, seed, Scalar(255,0,0), &ccomp, Scalar(loDiff, loDiff, loDiff), Scalar(upDiff, upDiff, upDiff), flags);
        }
        
        //Check new floodfill mask match for a correct patch.
        //Get all points detected for get Minimal rotated Rect
        vector<Point> pointsInterest;
        Mat_<uchar>::iterator itMask= mask.begin<uchar>();
        Mat_<uchar>::iterator end= mask.end<uchar>();
        for( ; itMask!=end; ++itMask)
            if(*itMask==255)
                pointsInterest.push_back(itMask.pos());

        RotatedRect minRect = minAreaRect(pointsInterest);

        if(verifySizes(minRect)) {
            // rotated rectangle drawing 
            Point2f rect_points[4]; minRect.points( rect_points );
            for( int j = 0; j < 4; j++ )
                line( result, rect_points[j], rect_points[(j+1)%4], Scalar(0,0,255), 1, 8 );    

            //Get rotation matrix
            float r= (float)minRect.size.width / (float)minRect.size.height;
            float angle=minRect.angle;    
            if(r<1)
                angle=90+angle;
            Mat rotmat= getRotationMatrix2D(minRect.center, angle,1);

            //Create and rotate image
            Mat img_rotated;
            warpAffine(input, img_rotated, rotmat, input.size(), INTER_CUBIC);

            //Crop image
            Size rect_size=minRect.size;
            if(r < 1)
                swap(rect_size.width, rect_size.height);
            Mat img_crop;
            getRectSubPix(img_rotated, rect_size, minRect.center, img_crop);
            
            Mat resultResized;
            resultResized.create(69,300, CV_8UC3);
            resize(img_crop, resultResized, resultResized.size(), 0, 0, INTER_CUBIC);
            //Equalize croped image
            Mat grayResult;
            cvtColor(resultResized, grayResult, COLOR_BGR2GRAY);
            blur(grayResult, grayResult, Size(3,3));
            grayResult=histeq(grayResult);
            
            Mat new_image = enhanceContrast(resultResized);
            output.push_back(Plate(new_image,minRect.boundingRect()));
            
//            output.push_back(Plate(grayResult,minRect.boundingRect()));
        }
    }
    
    cout<<"detected plate regions:"<<output.size()<<endl;
    
//    for (int i = 0; i < output.size(); i++) {
//        Plate rect = output[i];
//        rectangle(result, rect.position, Scalar(255,0,0), 3);
//    }
//    output.push_back(Plate(result, Rect(Point(0,0), result.size())));

    return output;
}

vector<Plate> DetectRegions::run(Mat input) {
    
    //Segment image by white 
    vector<Plate> tmp=segment(input);

    //return detected and posibles regions
    return tmp;
}


#pragma mark - Begin new methods

Mat DetectRegions::getGrayScaleMat(Mat source) {
    
    cv::Mat gray;
    if (source.channels() == 3)
        cv::cvtColor(source, gray, cv::COLOR_BGR2GRAY);
    else if (source.channels() == 4)
        cv::cvtColor(source, gray, cv::COLOR_BGRA2GRAY);
    else if(source.channels() == 1)
        gray = source;
    
    return gray;
}
Mat DetectRegions::getBlurMat(Mat source) {
   
    Mat output;
    source.copyTo(output);
    
    blur(output, output, Size(5,5));
    
    return output;
}
Mat DetectRegions::getSobelFilteredMat(Mat img_gray) {
    Mat img_sobel;

    Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    
    return img_sobel;
}
Mat DetectRegions::getThresholdMat(Mat img_sobel) {

    Mat img_threshold;
    
    threshold(img_sobel, img_threshold, 0, 255, THRESH_OTSU+THRESH_BINARY);
    
    return img_threshold;
}
Mat DetectRegions::getMorpholgyMat(Mat img_sobel) {
    
    Mat img_threshold = getThresholdMat(img_sobel);
    
    //Morphplogic operation close
    Mat element = getStructuringElement(MORPH_RECT, Size(17, 3) );
    morphologyEx(img_threshold, img_threshold, MORPH_CLOSE, element);
    
    return img_threshold;
}
vector<RotatedRect> DetectRegions::getPossibleRegionsAfterFindContour(Mat img_threshold) {
    
    //Find contours of possibles plates
    vector< vector< Point> > contours;
    findContours(img_threshold,
                 contours, // a vector of contours
                 RETR_EXTERNAL, // retrieve the external contours
                 CHAIN_APPROX_NONE); // all pixels of each contours
    
    //Start to iterate to each contour founded
    vector<vector<Point> >::iterator itc= contours.begin();
    vector<RotatedRect> rects;
    
    //Remove patch that are no inside limits of aspect ratio and area.
    while (itc!=contours.end()) {
        //Create bounding rect of object
        RotatedRect mr= minAreaRect(Mat(*itc));
        if( !verifySizes(mr)){
            itc= contours.erase(itc);
        }else{
            ++itc;
            rects.push_back(mr);
        }
    }
    cout<<"number of possible regions:"<<rects.size()<<endl;

    return rects;
}
cv::RotatedRect DetectRegions::getDetectedPlateRect(Mat mask) {

    vector<Point> pointsInterest;
    Mat_<uchar>::iterator itMask= mask.begin<uchar>();
    Mat_<uchar>::iterator end= mask.end<uchar>();
    for( ; itMask!=end; ++itMask)
        if(*itMask==255)
            pointsInterest.push_back(itMask.pos());
    
    RotatedRect minRect = minAreaRect(pointsInterest);

    return minRect;
}
Mat DetectRegions::getRotatedMatFromDetectedRectangle(RotatedRect source) {
    
    float r= (float)source.size.width / (float)source.size.height;
    float angle=source.angle;
    if(r<1)
        angle=90+angle;
    Mat rotmat= getRotationMatrix2D(source.center, angle,1);
    
    return rotmat;
}
Mat  DetectRegions::getRotatedMat(Mat source, Mat rotmat) {
    
    //Create and rotate image
    Mat img_rotated;
    warpAffine(source, img_rotated, rotmat, source.size(), INTER_CUBIC);
    
    return img_rotated;
}
Mat DetectRegions::getCroppedMat(Mat img_rotated, RotatedRect rect) {
    
    float r= (float)rect.size.width / (float)rect.size.height;
    //Crop image
    Size rect_size=rect.size;
    if(r < 1)
        swap(rect_size.width, rect_size.height);
    Mat img_crop;
    getRectSubPix(img_rotated, rect_size, rect.center, img_crop);
    
    Mat output;
    return output;
}
Mat DetectRegions::getResizedMat(Mat img_crop, cv::Size size) {
    
    Mat resultResized;
    
    resultResized.create(size.height,size.width, CV_8UC3);
    resize(img_crop, resultResized, resultResized.size(), 0, 0, INTER_CUBIC);
    
    return resultResized;
}
Mat DetectRegions::getNormalisedGrayscaleMat(Mat resultResized) {
    
    Mat grayResult;
    
    cvtColor(resultResized, grayResult, COLOR_BGR2GRAY);
    grayResult = histogramEqualizedMat(grayResult);
    
    return grayResult;
}
Mat DetectRegions::histogramEqualizedMat(Mat source) {
    
    Mat output;
    source.copyTo(output);
    
    blur(output, output, Size(3,3));
    output=histeq(output);
    
    return output;
}

#pragma mark - Adnan work

Mat DetectRegions::testingDrawRegion(Mat input) {
    
    Mat img_gray, gray;
    
    if (input.channels() == 3)
        cv::cvtColor(input, gray, COLOR_BGR2GRAY);
    else if (input.channels() == 4) {
        Mat temp;
        cv::cvtColor(input, temp, COLOR_BGRA2BGR);
        cv::cvtColor(input, gray, COLOR_BGRA2GRAY);
        temp.copyTo(input);
    }
    else if(input.channels() == 1)
        gray = input;
    
    img_gray = blurImage(gray);
    
    Mat img_sobel = edgeDetection(img_gray);
    
    Mat img_threshold = imageMorphology(img_sobel);
    
    vector< vector< Point> > contours;
    
    findContours(img_threshold,
                 contours, // a vector of contours
                 RETR_LIST, // retrieve the external contours
                 CHAIN_APPROX_SIMPLE); // all pixels of each contours
    
    //Start to iterate to each contour founded
    vector<vector<Point> >::iterator itc= contours.begin();
    vector<RotatedRect> rects;
    
    vector<Point> approx;
    cv::Mat result;
    input.copyTo(result);
    
    while (itc!=contours.end()) {
        //Create bounding rect of object
        
        approxPolyDP(Mat(*itc), approx, arcLength(Mat(*itc), true)*0.02, true);
        
        RotatedRect mr= minAreaRect(Mat(*itc));
        
        //        const Point topLeft = Point(mr.center.x-mr.size.width/2, mr.center.y - mr.size.height/2);
        //        const Point bottomRight = Point(mr.center.x+mr.size.width/2, mr.center.y + mr.size.height/2);
        //
        //        if (mr.size.width > 200 && mr.size.height > 50 && mr.size.height < 100 && mr.size.width < 320)
        //        {
        //            rectangle(result, topLeft , bottomRight , Scalar(0,255,0), 2);
        //            circle(result, mr.center, 5, Scalar(0,255,0), -1);
        //            rects.push_back(mr);
        //
        //        }
        //
        //        ++itc;
        //        continue;
        
        if( !verifySizes(mr)){
            itc= contours.erase(itc);
        }else{
            ++itc;
            rects.push_back(mr);
            //            const Point topLeft = Point(mr.center.x-mr.size.width/2, mr.center.y - mr.size.height/2);
            //            const Point bottomRight = Point(mr.center.x+mr.size.width/2, mr.center.y + mr.size.height/2);
            //            rectangle(result, topLeft, bottomRight, Scalar(0,255,0), 2);
            circle(result, mr.center, 5, Scalar(0,255,0), -1);
        }
    }
    
    //    return result;
    
    vector<Plate> regions;
    
    cout <<"---- Actual Specification ----"<<endl;
    
    for(int i=0; i< rects.size(); i++){
        
        circle(result, rects[i].center, 5, Scalar(0,255,0), -1);
        
        float minSize=(rects[i].size.width < rects[i].size.height)?rects[i].size.width:rects[i].size.height;
        minSize = minSize-minSize*0.5;
        srand ( time(NULL) );
        
        Mat mask;
        mask.create(gray.rows + 2, gray.cols + 2, CV_8UC1);
        mask= Scalar::all(0);
        
        int loDiff = 30;
        int upDiff = 30;
        int connectivity = 4;
        int newMaskVal = 255;
        int NumSeeds = 20;
        Rect ccomp;
        int flags = connectivity + (newMaskVal << 8 ) + FLOODFILL_FIXED_RANGE + FLOODFILL_MASK_ONLY;
        for(int j=0; j<NumSeeds; j++){
            Point seed;
            seed.x=rects[i].center.x+rand()%(int)minSize-(minSize/2);
            seed.y=rects[i].center.y+rand()%(int)minSize-(minSize/2);
            circle(result, seed, 1, Scalar(0,255,255), -1);
            cv::floodFill(gray, mask, seed, Scalar(255,0,0), &ccomp, Scalar(loDiff, loDiff, loDiff), Scalar(upDiff, upDiff, upDiff), flags);
        }
        
        //        return mask;
        
        vector<Point> pointsInterest;
        Mat_<uchar>::iterator itMask= mask.begin<uchar>();
        Mat_<uchar>::iterator end= mask.end<uchar>();
        for( ; itMask!=end; ++itMask)
            if(*itMask==255)
                pointsInterest.push_back(itMask.pos());
        
        
        RotatedRect minRect = minAreaRect(pointsInterest);
        
        if(verifySizes(minRect)){
            
            Point2f rect_points[4];
            minRect.points( rect_points );
            for( int j = 0; j < 4; j++ )
                line( result, rect_points[j], rect_points[(j+1)%4], Scalar(0,0,255), 1, 8 );
            
            
            float r= (float)minRect.size.width / (float)minRect.size.height;
            float angle=minRect.angle;
            if(r<1)
                angle=90+angle;
            Mat rotmat= getRotationMatrix2D(minRect.center, angle,1);
            
            
            Mat img_rotated;
            warpAffine(gray, img_rotated, rotmat, gray.size(), INTER_CUBIC);     //-----------------------
            
            
            Size rect_size=minRect.size;
            if(r < 1)
                swap(rect_size.width, rect_size.height);
            Mat img_crop;
            getRectSubPix(img_rotated, rect_size, minRect.center, img_crop);
            
            Mat resultResized;
            resultResized.create(33,144, CV_8UC3);
            resize(img_crop, resultResized, resultResized.size(), 0, 0, INTER_CUBIC);
            
            Mat grayResult(resultResized);
            blur(grayResult, grayResult, Size(3,3));
            grayResult=histeq(grayResult);
            
            regions.push_back(Plate(input(minRect.boundingRect()).clone(),minRect.boundingRect()));
            
        }
    }
    
    vector<Plate>::iterator tmp1 = regions.begin();
    
    while (tmp1 != regions.end()) {
        
        bool overlap = false;
        vector<Plate>::iterator tmp;
        vector<Plate>::iterator tmp2 = regions.begin();
        while (tmp2!=regions.end()) {
            
            if (tmp1 != tmp2) {
                Point P1(tmp1->position.x, tmp1->position.y);
                Point P2(tmp1->position.x + tmp1->position.width, tmp1->position.y + tmp1->position.height);
                Point P3(tmp2->position.x, tmp2->position.y);
                Point P4(tmp2->position.x + tmp2->position.width, tmp2->position.y + tmp2->position.height);
                
                if (P1.x < P4.x && P2.x > P3.x &&
                    P1.y < P4.y && P2.y > P3.y) {
                    //                    cout <<"Overlap Regions: "<< tmp1->position << "--" <<tmp2->position << endl;
                    overlap = true;
                    if (tmp1->position.width > tmp2->position.width) {
                        tmp = tmp2;
                    } else {
                        tmp = tmp1;
                    }
                    break;
                }
            }
            ++tmp2;
        }
        
        
        if (overlap) {
            regions.erase(tmp);
        } else {
            ++tmp1;
        }
    }
    
    for (int i = 0; i < regions.size(); i++) {
        Plate rect = regions[i];
        rectangle(result, rect.position, Scalar(255,0,0), 3);
    }
    
    regions.push_back(Plate(result, Rect(Point(0,0), result.size())));
    
    return result;
    
}
Mat DetectRegions::edgeDetection(Mat input) {
    
    Mat img_sobel;
    //    Sobel(input, img_sobel, CV_8U, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    Canny(input, img_sobel, 0, 150, 5);
    dilate(img_sobel, img_sobel, Mat(), Point(-1,-1), 1);
    
    return img_sobel;
}
Mat DetectRegions::blurImage(Mat input) {
    
    Mat output;
    input.copyTo(output);
    blur(output, output, Size(5,5));
    return output;
}
Mat DetectRegions::imageMorphology(Mat input) {
    Mat img_threshold;
    threshold(input, img_threshold, 0, 255, THRESH_OTSU+THRESH_BINARY);
    
    Mat element = getStructuringElement(MORPH_RECT, Size(5, 5) );
    morphologyEx(img_threshold, img_threshold, MORPH_CLOSE, element);
    
    return img_threshold;
}

#pragma mark - Chapter 5 code.

vector<Plate> DetectRegions::segment5(Mat input){
    vector<Plate> output;
    
    //convert image to gray
    Mat img_gray;
    cvtColor(input, img_gray, CV_BGR2GRAY);
    blur(img_gray, img_gray, Size(5,5));
    
    //Finde vertical lines. Car plates have high density of vertical lines
    Mat img_sobel;
    Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    if(showSteps)
        imshow("Sobel", img_sobel);
    
    //threshold image
    Mat img_threshold;
    threshold(img_sobel, img_threshold, 0, 255, CV_THRESH_OTSU+CV_THRESH_BINARY);
    if(showSteps)
        imshow("Threshold", img_threshold);
    
    //Morphplogic operation close
    Mat element = getStructuringElement(MORPH_RECT, Size(17, 3) );
    morphologyEx(img_threshold, img_threshold, CV_MOP_CLOSE, element);
    if(showSteps)
        imshow("Close", img_threshold);
    
    //Find contours of possibles plates
    vector< vector< Point> > contours;
    findContours(img_threshold,
                 contours, // a vector of contours
                 CV_RETR_EXTERNAL, // retrieve the external contours
                 CV_CHAIN_APPROX_NONE); // all pixels of each contours
    
    //Start to iterate to each contour founded
    vector<vector<Point> >::iterator itc= contours.begin();
    vector<RotatedRect> rects;
    
    //Remove patch that are no inside limits of aspect ratio and area.
    while (itc!=contours.end()) {
        //Create bounding rect of object
        RotatedRect mr= minAreaRect(Mat(*itc));
        if( !verifySizes(mr)){
            itc= contours.erase(itc);
        }else{
            ++itc;
            rects.push_back(mr);
        }
    }
    
    // Draw blue contours on a white image
    cv::Mat result;
    input.copyTo(result);
    cv::drawContours(result,contours,
                     -1, // draw all contours
                     cv::Scalar(255,0,0), // in blue
                     1); // with a thickness of 1
    
    for(int i=0; i< rects.size(); i++){
        
        //For better rect cropping for each posible box
        //Make floodfill algorithm because the plate has white background
        //And then we can retrieve more clearly the contour box
        circle(result, rects[i].center, 3, Scalar(0,255,0), -1);
        //get the min size between width and height
        float minSize=(rects[i].size.width < rects[i].size.height)?rects[i].size.width:rects[i].size.height;
        minSize=minSize-minSize*0.5;
        //initialize rand and get 5 points around center for floodfill algorithm
        srand ( time(NULL) );
        //Initialize floodfill parameters and variables
        Mat mask;
        mask.create(input.rows + 2, input.cols + 2, CV_8UC1);
        mask= Scalar::all(0);
        int loDiff = 30;
        int upDiff = 30;
        int connectivity = 4;
        int newMaskVal = 255;
        int NumSeeds = 10;
        Rect ccomp;
        int flags = connectivity + (newMaskVal << 8 ) + CV_FLOODFILL_FIXED_RANGE + CV_FLOODFILL_MASK_ONLY;
        for(int j=0; j<NumSeeds; j++){
            Point seed;
            seed.x=rects[i].center.x+rand()%(int)minSize-(minSize/2);
            seed.y=rects[i].center.y+rand()%(int)minSize-(minSize/2);
            circle(result, seed, 1, Scalar(0,255,255), -1);
            floodFill(input, mask, seed, Scalar(255,0,0), &ccomp, Scalar(loDiff, loDiff, loDiff), Scalar(upDiff, upDiff, upDiff), flags);
        }
        if(showSteps)
            imshow("MASK", mask);
        //cvWaitKey(0);
        
        //Check new floodfill mask match for a correct patch.
        //Get all points detected for get Minimal rotated Rect
        vector<Point> pointsInterest;
        Mat_<uchar>::iterator itMask= mask.begin<uchar>();
        Mat_<uchar>::iterator end= mask.end<uchar>();
        for( ; itMask!=end; ++itMask)
            if(*itMask==255)
                pointsInterest.push_back(itMask.pos());
        
        RotatedRect minRect = minAreaRect(pointsInterest);
        
        if(verifySizes(minRect)){
            // rotated rectangle drawing
            Point2f rect_points[4]; minRect.points( rect_points );
            for( int j = 0; j < 4; j++ )
                line( result, rect_points[j], rect_points[(j+1)%4], Scalar(0,0,255), 1, 8 );
            
            //Get rotation matrix
            float r= (float)minRect.size.width / (float)minRect.size.height;
            float angle=minRect.angle;
            if(r<1)
                angle=90+angle;
            Mat rotmat= getRotationMatrix2D(minRect.center, angle,1);
            
            //Create and rotate image
            Mat img_rotated;
            warpAffine(input, img_rotated, rotmat, input.size(), CV_INTER_CUBIC);
            
            //Crop image
            Size rect_size=minRect.size;
            if(r < 1)
                swap(rect_size.width, rect_size.height);
            Mat img_crop;
            getRectSubPix(img_rotated, rect_size, minRect.center, img_crop);
            
            Mat resultResized;
            resultResized.create(33,144, CV_8UC3);
            resize(img_crop, resultResized, resultResized.size(), 0, 0, INTER_CUBIC);
            //Equalize croped image
            Mat grayResult;
            cvtColor(resultResized, grayResult, CV_BGR2GRAY);
            blur(grayResult, grayResult, Size(3,3));
            grayResult=histeq(grayResult);
            if(saveRegions){
                stringstream ss(stringstream::in | stringstream::out);
                ss << "tmp/" << filename << "_" << i << ".jpg";
                imwrite(ss.str(), grayResult);
            }
            output.push_back(Plate(grayResult,minRect.boundingRect()));
        }
    }       
    if(showSteps) 
        imshow("Contours", result);
    
    return output;
}

#pragma mark - 6 step code.

Mat LPRalgorithm(Mat src_img) {
    
    Mat plate = Mat(0, 0, 0);
    
    double prate=0;
    cv::Mat src_gray, src_gray2, dst_img1, dst_img2, dst_img3, dst_img4;
    std::vector<std::vector<cv::Point>> strage;
    
    //Crop image (640x480 -> 320x240)
    src_img = src_img(cv::Rect(160,160,320,240));
    
    //Convert to grayscale
    cv::cvtColor(src_img, src_gray, CV_RGB2GRAY);
    
    //Gaussian filter (Noise reduction)
    cv::GaussianBlur(src_gray, src_gray2, cv::Size(5,5), 0);
    
    //Edge detection (Use canny method)
    cv::Canny(src_gray2, dst_img1, 150, 255);
    
    //Copy matrix (This is unnecessary code when porting on Android)
    dst_img2 = dst_img1.clone();
    
    //Find the contours in image
    cv::findContours(dst_img2, strage, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_TC89_KCOS);
    
    int offs = 4; //Offset of crop to use in nest process
    
    //Search area of the plate with the correct aspect ratio
    for (int i = 0; i < strage.size(); i++) {
        size_t count = strage[i].size();
        if (count > 0) {
            cv::Mat pointr;
            cv::Rect rect;
            cv::Mat(strage[i]).convertTo(pointr, CV_32F);
            rect = cv::boundingRect(pointr);
            
            //Calculate aspect ratio
            prate = rect.width/rect.height;
            if (prate >=3 && prate <4.5 && rect.width < 250 && rect.width > 150){
                
                //Write rectangle to original image
                cv::rectangle(src_img, cv::Point(rect.x,rect.y), cvPoint (rect.x + rect.width, rect.y + rect.height), CV_RGB (0, 255, 0), 2);
                
                //Crop plate image
                dst_img3 = src_gray(cv::Rect(rect.x+offs,rect.y+offs,rect.width-2*offs,rect.height-2*offs));
                dst_img4 = dst_img1(cv::Rect(rect.x+offs,rect.y+offs,rect.width-2*offs,rect.height-2*offs));
                break;
            }
        }
    }
    
    //If detection has failed, stop the program
    if (dst_img3.empty()) {
        return plate;
    }
    
    return dst_img3;
}

#pragma mark - ANPR Christian Roman

Mat DetectRegions::preProcessing(cv::Mat source) {
    
    /* Pre-processing */
    
    cv::Mat img_gray;
    cv::cvtColor(source, img_gray, CV_BGR2GRAY);
    blur(img_gray, img_gray, cv::Size(5,5));
    //medianBlur(img_gray, img_gray, 9);
    cv::Mat img_sobel;
    cv::Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, cv::BORDER_DEFAULT);
    cv::Mat img_threshold;
    threshold(img_gray, img_threshold, 0, 255, CV_THRESH_OTSU+CV_THRESH_BINARY);
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(3, 3) );
    morphologyEx(img_threshold, img_threshold, CV_MOP_CLOSE, element);
    
    /* Search for contours */
    
    std::vector<std::vector<cv::Point> > contours;
    cv::Mat contourOutput = img_threshold.clone();
    cv::findContours( contourOutput, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE );
    
    std::vector<cv::Vec4i> hierarchy;
    
    /* Get the largest contour (Possible license plate) */
    
    int largestArea = -1;
    std::vector<std::vector<cv::Point> > largestContour;
    
    std::vector<std::vector<cv::Point> > polyContours( contours.size() );
    
    //std::vector<cv::Point> approx;
    for( int i = 0; i < contours.size(); i++ ){
        approxPolyDP( cv::Mat(contours[i]), polyContours[i], arcLength(cv::Mat(contours[i]), true)*0.02, true );
        
        if (polyContours[i].size() == 4 && fabs(contourArea(cv::Mat(polyContours[i]))) > 1000 && isContourConvex(cv::Mat(polyContours[i]))){
            double maxCosine = 0;
            
            for (int j = 2; j < 5; j++){
                double cosine = fabs(preProcessingangle(polyContours[i][j%4], polyContours[i][j-2], polyContours[i][j-1]));
                
                maxCosine = MAX(maxCosine, cosine);
            }
            
            if (maxCosine < 0.3)
                cout<<"Square detected"<<endl;
        }
    }
    
    for( int i = 0; i< polyContours.size(); i++ ){
        
        int area = fabs(contourArea(polyContours[i],false));
        if(area > largestArea){
            largestArea = area;
            largestContour.clear();
            largestContour.push_back(polyContours[i]);
        }
        
    }
    
    // Contour drawing debug
    cv::Mat drawing = cv::Mat::zeros( contourOutput.size(), CV_8UC3 );
    if(largestContour.size()>=1){
        
        cv::drawContours(source, largestContour, -1, cv::Scalar(0, 255, 0), 0);
        
    }
    
    /* Get RotatedRect for the largest contour */
    
    std::vector<cv::RotatedRect> minRect( largestContour.size() );
    for( int i = 0; i < largestContour.size(); i++ )
        minRect[i] = minAreaRect( cv::Mat(largestContour[i]) );
    
    cv::Mat drawing2 = cv::Mat::zeros( img_threshold.size(), CV_8UC3 );
    for( int i = 0; i< largestContour.size(); i++ ){
        
        cv::Point2f rect_points[4]; minRect[i].points( rect_points );
        for( int j = 0; j < 4; j++ ){
            line( drawing2, rect_points[j], rect_points[(j+1)%4], cv::Scalar(0,255,0), 1, 8 );
            
        }
        
    }
    
    /* Get Region Of Interest ROI */
    
    cv::RotatedRect box = minAreaRect( cv::Mat(largestContour[0]));
    cv::Rect box2 = cv::RotatedRect(box.center, box.size, box.angle).boundingRect();
    
    cv::Size rect_size=box.size;
    //Get rotation matrix
    float r= (float)box.size.width / (float)box.size.height;
    if(r < 1)
        swap(rect_size.width, rect_size.height);
    Mat img_crop;
    getRectSubPix(img_threshold, rect_size, box.center, img_crop);
    
    
    box2.x += box2.width * 0.028;
    box2.width -= box2.width * 0.05;
    box2.y += box2.height * 0.25;
    box2.height -= box2.height * 0.55;
    
    //    cv::Mat cvMat = img_threshold(box2).clone();
    
    /* Experimental
     
     cv::Point2f pts[4];
     
     std::vector<cv::Point> shape;
     
     shape.push_back(largestContour[0][3]);
     shape.push_back(largestContour[0][2]);
     shape.push_back(largestContour[0][1]);
     shape.push_back(largestContour[0][0]);
     
     cv::RotatedRect boxx = minAreaRect(cv::Mat(shape));
     
     box.points(pts);
     
     cv::Point2f src_vertices[3];
     src_vertices[0] = shape[0];
     src_vertices[1] = shape[1];
     src_vertices[2] = shape[3];
     
     cv::Point2f dst_vertices[3];
     dst_vertices[0] = cv::Point(0, 0);
     dst_vertices[1] = cv::Point(boxx.boundingRect().width-1, 0);
     dst_vertices[2] = cv::Point(0, boxx.boundingRect().height-1);
     
     cv::Mat warpAffineMatrix = getAffineTransform(src_vertices, dst_vertices);
     
     cv::Mat rotated;
     cv::Size size(boxx.boundingRect().width, boxx.boundingRect().height);
     cv::warpAffine(source, rotated, warpAffineMatrix, size, cv::INTER_LINEAR, cv::BORDER_CONSTANT);
     
     */
    
    return img_crop;
}
double DetectRegions::preProcessingangle( cv::Point pt1, cv::Point pt2, cv::Point pt0 ) {
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1 * dx2 + dy1 * dy2)/sqrt((dx1 * dx1 + dy1 * dy1) * (dx2 * dx2 + dy2 * dy2) + 1e-10);
}
Mat DetectRegions::enhanceContrast(Mat resultResized) {
    
    Mat new_image; // = Mat::zeros( resultResized.size(), resultResized.type() );

    resultResized.convertTo(new_image, -1, 2.2, 0);
    
    return new_image;
}
Mat DetectRegions::enhanceSharpness(cv::Mat source) {
    Mat destination = Mat(source.size(), source.type());
    
    blur(source, destination, Size(3,3));
    addWeighted(source, 1.5, destination, -0.5, 0, destination);
    
    return destination;
}
