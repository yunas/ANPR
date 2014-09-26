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
    minArea = 15;
    maxArea = 125;
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

vector<Plate> DetectRegions::segment(Mat input){
    
    vector<Plate> output;

    //convert image to gray
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
    
    blur(img_gray, img_gray, Size(5,5));

    //Finde vertical lines. Car plates have high density of vertical lines
    Mat img_sobel;
    Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    
    //threshold image
    Mat img_threshold;
    threshold(img_sobel, img_threshold, 0, 255, THRESH_OTSU+THRESH_BINARY);
    
    //Morphplogic operation close
    Mat element = getStructuringElement(MORPH_RECT, Size(17, 3) );
    morphologyEx(img_threshold, img_threshold, MORPH_CLOSE, element);

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
        srand (time(NULL) );
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
            warpAffine(input, img_rotated, rotmat, input.size(), INTER_CUBIC);

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
            cvtColor(resultResized, grayResult, COLOR_BGR2GRAY);
            blur(grayResult, grayResult, Size(3,3));
            grayResult=histeq(grayResult);
            
            output.push_back(Plate(grayResult,minRect.boundingRect()));
        }
    }       
    
    for (int i = 0; i < output.size(); i++) {
        Plate rect = output[i];
        rectangle(result, rect.position, Scalar(0,255,0), 3);
    }
    
    output.push_back(Plate(result, Rect(Point(0,0), result.size())));

    return output;
}

vector<Plate> DetectRegions::run(Mat input){
    
    //Segment image by white 
    vector<Plate> tmp=segment(input);

    //return detected and posibles regions
    return tmp;
}

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

Mat DetectRegions::edgeDetection(Mat input)
{
    Mat img_sobel;
    //    Sobel(input, img_sobel, CV_8U, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    Canny(input, img_sobel, 0, 150, 5);
    dilate(img_sobel, img_sobel, Mat(), Point(-1,-1), 1);
    
    return img_sobel;
}
Mat DetectRegions::blurImage(Mat input)
{
    Mat output;
    input.copyTo(output);
    
    blur(output, output, Size(5,5));
//    blur(output, output, Size(5,5));
//    blur(output, output, Size(5,5));
    //    blur(output, output, Size(5,5));
    
    return output;
}
Mat DetectRegions::imageMorphology(Mat input)
{
    Mat img_threshold;
    threshold(input, img_threshold, 0, 255, THRESH_OTSU+THRESH_BINARY);
    
    Mat element = getStructuringElement(MORPH_RECT, Size(5, 5) );
    morphologyEx(img_threshold, img_threshold, MORPH_CLOSE, element);
    
    return img_threshold;
}
