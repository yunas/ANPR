//
//  ImageProcessor.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 08/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ImageProcessorImplementation.h"
#import "UIImage+OpenCV.h"
#import <opencv2/imgproc/imgproc.hpp>

#include "DetectRegions.h"
#include "HarissDetector.h"

using namespace std;

@implementation ImageProcessorImplementation

#pragma mark - Class methods

+ (void)getLocalisedImageFromSource:(UIImage*)image imageName:(NSString *)name result:(ImageProcessingDone)block {

    // input image
    cv::Mat input_image = [image CVMat];

    DetectRegions detectRegions;
    detectRegions.setFilename("12");
    detectRegions.saveRegions = false;
    detectRegions.showSteps = false;
    
    vector<Plate> posible_regions = detectRegions.run(input_image);
    
    UIImage *outImage = nil;
    NSData *data = nil;
    NSString* filePath = nil;
    
    for (int i=0; i<posible_regions.size(); i++) {
        
        Plate rect = posible_regions[i];
        
        outImage = [UIImage imageWithCVMat:rect.plateImg];
        
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        
//        filePath = [documentsPath stringByAppendingFormat:@"/%@_%d_0.jpg",name,i];
//        
//        data = UIImageJPEGRepresentation(outImage, 1);
//        
//        [data writeToFile:filePath atomically:YES];
    }
    
//    return outImage;
    
    //SVM for each plate region to get valid car plates
    //Read file storage.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docs = [paths objectAtIndex:0];
//    NSString *vocabPath = [docs stringByAppendingPathComponent:@"SVM.xml"];
    
    NSString *vocabPath = [[NSBundle mainBundle] pathForResource:@"SVM.xml" ofType:nil];
    FileStorage fs([vocabPath UTF8String], FileStorage::READ);
    Mat SVM_TrainingData;
    Mat SVM_Classes;
    fs["TrainingData"] >> SVM_TrainingData;
    fs["classes"] >> SVM_Classes;
    //Set SVM params
    
    CvSVMParams SVM_params;
    SVM_params.svm_type = CvSVM::C_SVC;
    SVM_params.kernel_type = CvSVM::LINEAR;
    SVM_params.degree = 0;
    SVM_params.gamma = 1;
    SVM_params.coef0 = 0;
    SVM_params.C = 1;
    SVM_params.nu = 0;
    SVM_params.p = 0;
    SVM_params.term_crit = cvTermCriteria(CV_TERMCRIT_ITER, 1000, 0.01);
    //Train SVM
    CvSVM svmClassifier(SVM_TrainingData, SVM_Classes, Mat(), Mat(), SVM_params);
    
    //For each possible plate, classify with svm if it's a plate or no
    vector<Plate> plates;
    for(int i=0; i< posible_regions.size()-1; i++)
    {
        Mat img=posible_regions[i].plateImg;
        Mat p= img.reshape(1, 1);
        p.convertTo(p, CV_32FC1);
        
        int response = (int)svmClassifier.predict( p );
        if(response==1)
            plates.push_back(posible_regions[i]);
    }
    
    for (int i=0; i<plates.size(); i++) {
        Plate rect = plates[i];
        
        outImage = [UIImage imageWithCVMat:rect.plateImg];
        
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        
//        filePath = [documentsPath stringByAppendingFormat:@"/%@_%d_svm.jpg",name,i];
//        
//        data = UIImageJPEGRepresentation(outImage, 1);
//        
//        [data writeToFile:filePath atomically:YES];
    }
    
    block(outImage);
}

+ (UIImage *)harissCornerDetector:(UIImage*)source {
    
    cv::Mat input_image = [source CVMat];
    
    HarissDetector hariss;
    cv::Mat outPut = hariss.cornerHarris_demo(input_image);
    
    UIImage *outPutImage = [UIImage imageWithCVMat:outPut];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"hariss.jpg"];
    
    NSData *data = UIImageJPEGRepresentation(outPutImage, 1);
    [data writeToFile:filePath atomically:YES];
    
    return outPutImage;
}

+ (UIImage *)ShiTomasiCornerDetector:(UIImage*)source {
    cv::Mat input_image = [source CVMat];
    
    
    HarissDetector hariss;
    
    cv::Mat output = hariss.goodFeaturesToTrack_Demo(input_image);
    
    UIImage *outPutImage = [UIImage imageWithCVMat:output];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"shi.jpg"];
    
    NSData *data = UIImageJPEGRepresentation(outPutImage, 1);
    [data writeToFile:filePath atomically:YES];
    
    return outPutImage;
    
}

+ (BOOL)trainSVM {
    
    int numPlates = 48;
    int numNoPlates = 29;
    
    cv::Mat classes; // = Mat(numPlates+numNoPlates, 1, CV_32FC1);
    cv::Mat trainingData; // = Mat(numPlates+numNoPlates, 144*33, CV_32FC1 );
    
    cv::Mat trainingImages;
    std::vector<int> trainingLabels;
    
    for (int i=1; i<= numPlates; i++) {
        
        NSString *plateNumber = [NSString stringWithFormat:@"%d.jpg",i];
        
        cv::Mat img_gray = [[self class] trainingPlate:plateNumber];
        
        img_gray= img_gray.reshape(1, 1);
        trainingImages.push_back(img_gray);
        trainingLabels.push_back(1);
        
        img_gray.release();
    }
    
    for (int i=1; i<=numNoPlates; i++) {
        
        NSString *plateNumber = [NSString stringWithFormat:@"n%d.jpg",i];
        
        cv::Mat img_gray = [[self class] trainingPlate:plateNumber];
        
        img_gray= img_gray.reshape(1, 1);
        trainingImages.push_back(img_gray);
        trainingLabels.push_back(0);
    }
    
    Mat(trainingImages).copyTo(trainingData);
    //trainingData = trainingData.reshape(1,trainingData.rows);
    trainingData.convertTo(trainingData, CV_32FC1);
    Mat(trainingLabels).copyTo(classes);
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"SVM.xml"];
    FileStorage fs([filePath UTF8String], FileStorage::WRITE);
    fs << "TrainingData" << trainingData;
    fs << "classes" << classes;
    fs.release();
    
    return YES;
}

+ (Mat)trainingPlate:(NSString*)platenumber {
    
    UIImage *image = [UIImage imageNamed:platenumber];
    
    cv::Mat src = [image CVMat];
    cv::Mat img_gray = [[self class] grayImage:src];

    return img_gray;
}

#pragma mark - instance methods


- (NSString*)filePath:(NSString*)name {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingFormat:@"/l%@.jpg",name];
    
    return filePath;
}

+ (cv::Mat)grayImage:(cv::Mat)sourceImage {
    
    cv::Mat gray;
    if (sourceImage.channels() == 3)
        cv::cvtColor(sourceImage, gray, cv::COLOR_BGR2GRAY);
    else if (sourceImage.channels() == 4)
        cv::cvtColor(sourceImage, gray, cv::COLOR_BGRA2GRAY);
    else if(sourceImage.channels() == 1)
        gray = sourceImage;
    
    return gray;
}

- (UIImage*)LocalizeImageFromSource:(UIImage *)src {

    UIImage *filtered = nil;
    NSData *data = nil;
    NSString* filePath = nil;
    cv::Mat source = [src CVMat];
    
    cv::Mat img_gray;
    img_gray = [[self class] grayImage:source];  //cvtColor(source, img_gray, cv::COLOR_BGR2GRAY);
//    blur(img_gray, img_gray, cv::Size(5,5));
    
    filtered=[UIImage imageWithCVMat:img_gray];
    
    // Saving image step by step. Grayscale image
    filePath = [self filePath:@"gray"];
    data = UIImageJPEGRepresentation(filtered, 1);
    [data writeToFile:filePath atomically:YES];
    
    // Morpholy operation
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(3, 9));
    
    cv::Mat img_close_1;
    morphologyEx(img_gray, img_close_1, cv::MORPH_CLOSE, element);
    
/*    // function Dilation
    cv::Mat dilation_dst;
    dilate( img_gray, dilation_dst, element );
    
    filtered=[UIImage imageWithCVMat:dilation_dst];
    
    // Saving image step by step. Dialtion
    filePath = [self filePath:@"dialation"];
    data = UIImageJPEGRepresentation(filtered, 1);
    [data writeToFile:filePath atomically:YES];
    
    // Erosion
    cv::Mat erosion_dst;
    erode( dilation_dst, erosion_dst, element );
    
    filtered=[UIImage imageWithCVMat:erosion_dst];
    
    // Saving image step by step. Erosion
    filePath = [self filePath:@"erosion"];
    data = UIImageJPEGRepresentation(filtered,1);
    [data writeToFile:filePath atomically:YES];
    
    cv::Mat result = dilation_dst-erosion_dst;
    
    filtered=[UIImage imageWithCVMat:img_close];
    
    // Saving image step by step. Subtraction
    filePath = [self filePath:@"subtract"];
    data = UIImageJPEGRepresentation(filtered,1);
    [data writeToFile:filePath atomically:YES];
 */
    
    // Sobel operation
    cv::Mat img_sobel;
    Sobel(img_close_1, img_sobel, CV_8UC1, 1, 0, 3, 1, 0, cv::BORDER_DEFAULT);
    
    // Gaussian blur to remove noise
    cv::Mat img_blur;
    blur(img_sobel, img_blur, cv::Size(5,5));
    
    // Close morpholy operation
    cv::Mat img_close_2;
    morphologyEx(img_blur, img_close_2, cv::MORPH_CLOSE, element);
    
    cv::Mat img_threshold;
    threshold(img_close_2, img_threshold, 0.0, 255.0, cv::THRESH_BINARY+cv::THRESH_OTSU);
    
    /*
     Find possible regions of number plate in image.
    */
    
    std::vector<std::vector<cv::Point> > contours;
    cv::Mat contourOutput = img_close_2.clone();
    cv::findContours( contourOutput, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_NONE);
    
    std::vector<std::vector<cv::Point> >::iterator itc = contours.begin();
    std::vector<cv::RotatedRect> rects;

    while (itc != contours.end()) {
        
        cv::RotatedRect mr = cv::minAreaRect(cv::Mat(*itc));
        
        float area = fabs(cv::contourArea(*itc));
        float bbArea=mr.size.width * mr.size.height;
        float ratio = area/bbArea;
        
        if( (ratio < 0.45) || (bbArea < 400) ){
            itc= contours.erase(itc);
        }else{
            ++itc;
            rects.push_back(mr);
        }
    }
    
    // Draw blue contours on a white image
    cv::Mat result;
    img_gray.copyTo(result);
    cv::drawContours(result,contours,
                     -1, // draw all contours
                     cv::Scalar(255,0,0), // in blue
                     1); // with a thickness of 1
    
    
    
    for(int i=0; i< rects.size(); i++){
        
        //For better rect cropping for each posible box
        //Make floodfill algorithm because the plate has white background
        //And then we can retrieve more clearly the contour box
        circle(result, rects[i].center, 3, cv::Scalar(0,255,0), -1);
        //get the min size between width and height
        float minSize=(rects[i].size.width < rects[i].size.height)?rects[i].size.width:rects[i].size.height;
        minSize=minSize-minSize*0.5;
        //initialize rand and get 5 points around center for floodfill algorithm
        srand ( time(NULL) );
        //Initialize floodfill parameters and variables
        cv::Mat mask;
        mask.create(source.rows + 2, source.cols + 2, CV_8UC1);
        mask= cv::Scalar::all(0);
        int loDiff = 30;
        int upDiff = 30;
        int connectivity = 4;
        int newMaskVal = 255;
        int NumSeeds = 10;
        cv::Rect ccomp;
        int flags = connectivity + (newMaskVal << 8 ) + cv::FLOODFILL_FIXED_RANGE + cv::FLOODFILL_MASK_ONLY;
        for(int j=0; j<NumSeeds; j++){
            cv::Point seed;
            seed.x=rects[i].center.x+rand()%(int)minSize-(minSize/2);
            seed.y=rects[i].center.y+rand()%(int)minSize-(minSize/2);
            circle(result, seed, 1, cv::Scalar(0,255,255), -1);
            
//            int area = cv::floodFill(img_gray, mask, seed, cv::Scalar(255,0,0));

            cv::floodFill(img_gray, mask, seed, cv::Scalar(255,0,0), &ccomp, cv::Scalar(loDiff, loDiff, loDiff), cv::Scalar(upDiff, upDiff, upDiff), flags);
        }
        
        //Check new floodfill mask match for a correct patch.
        //Get all points detected for get Minimal rotated Rect
        std::vector<cv::Point> pointsInterest;
        cv::Mat_<uchar>::iterator itMask= mask.begin<uchar>();
        cv::Mat_<uchar>::iterator end= mask.end<uchar>();
        for( ; itMask!=end; ++itMask) {
            
            cout << &itMask <<endl;
            
            if(*itMask==255) {
                pointsInterest.push_back(itMask.pos());
            }
        }
        
        cv::RotatedRect minRect = cv::minAreaRect(cv::Mat(pointsInterest));
        
        if(verifySizes(minRect)){
            // rotated rectangle drawing
            cv::Point2f rect_points[4]; minRect.points( rect_points );
            for( int j = 0; j < 4; j++ )
                line( result, rect_points[j], rect_points[(j+1)%4], cv::Scalar(0,0,255), 1, 8 );
            
            //Get rotation matrix
            float r= (float)minRect.size.width / (float)minRect.size.height;
            float angle=minRect.angle;
            if(r<1)
                angle=90+angle;
            cv::Mat rotmat= getRotationMatrix2D(minRect.center, angle,1);
            
            //Create and rotate image
            cv::Mat img_rotated;
            warpAffine(img_gray, img_rotated, rotmat, img_gray.size(), cv::INTER_CUBIC);
            
            //Crop image
            cv::Size rect_size=minRect.size;
            if(r < 1)
                swap(rect_size.width, rect_size.height);
            cv::Mat img_crop;
            getRectSubPix(img_rotated, rect_size, minRect.center, img_crop);
            
            cv::Mat resultResized;
            resultResized.create(33,144, CV_8UC3);
            resize(img_crop, resultResized, resultResized.size(), 0, 0, cv::INTER_CUBIC);
            //Equalize croped image
            cv::Mat grayResult;
            cvtColor(resultResized, grayResult, cv::COLOR_BGR2GRAY);
            blur(grayResult, grayResult, cv::Size(3,3));
            grayResult=histeq(grayResult);
            filtered=[UIImage imageWithCVMat:grayResult];
//            output.push_back(Plate(grayResult,minRect.boundingRect()));
        }
    }
    
    
    
    // Saving image step by step. Sobel
    filePath = [self filePath:@"img_dst"];
    data = UIImageJPEGRepresentation(filtered,1);
    [data writeToFile:filePath atomically:YES];

    return filtered;
}

bool verifySizes(cv::RotatedRect mr){
    
    float error=0.4;
    //Spain car plate size: 52x11 aspect 4,7272
    float aspect=4.7272;
    //Set a min and max area. All other patchs are discarded
    int min= 15*aspect*15; // minimum area
    int max= 125*aspect*125; // maximum area
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

cv::Mat histeq(cv::Mat in) {
    
    cv::Mat out(in.size(), in.type());
    if(in.channels()==3){
        cv::Mat hsv;
        std::vector<cv::Mat> hsvSplit;
        cvtColor(in, hsv, cv::COLOR_BGR2HSV);
        split(hsv, hsvSplit);
        equalizeHist(hsvSplit[2], hsvSplit[2]);
        merge(hsvSplit, hsv);
        cvtColor(hsv, out, cv::COLOR_HSV2BGR);
    }else if(in.channels()==1){
        equalizeHist(in, out);
    }
    
    return out;
}

/* @function Dilation */
- (UIImage*)dilationOfSource:(UIImage *)src {
    
    cv::Mat source = [src CVMat];
    
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(3, 9));
    
    cv::Mat dilation_dst;
    dilate( source, dilation_dst, element );
    
    UIImage *filtered=[UIImage imageWithCVMat:dilation_dst];
    
    return filtered;
}

/* @function Erosion */
- (UIImage*)erosionOfSource:(UIImage *)src {
    
    cv::Mat source = [src CVMat];
    
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(3, 9));
    
    cv::Mat erosion_dst;
    
    /// Apply the erosion operation
    erode( source, erosion_dst, element );
        
    UIImage *filtered=[UIImage imageWithCVMat:erosion_dst];
    
    return filtered;
}




@end
