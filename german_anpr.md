# German ANPR 

##Characteristics of German number plate.
**1. Size of plate is 520x112 (mm)**  
**2. Type face (font) : FE-Schrift (“fälschungserschwerende Schrift”, tamper-hindering script).**  
**Maximum number of digits are 8**  
**Background coulour is white**  
**Text colour Black**  
**Border colour areound plate is Black**

## Steps for ANPR

###1. Plate detection
In this step number plate is detect in given image. Following steps are performed in this step.

**Segmentation:**

1. Convert input image to gray scale image. (**Note:** All operations in openCV are performed on grayscale images.).
2. Apply 5x5 gaussian filter to remove noise.
3. Sobel filter to find vertical edges.
4. Threshold filter using Otsu's algorithm determine optimal threshold value nd obtain binary image.
5. Close morphological operation to connect all vertical edges.
6. findcontours function to split into possible plate regions.
7. Iterate through obtained regions to get bounding rectangle of minimal area.
8. Apply floodfill algorithm to obtain mask image to store possible croping region. 
9. Use floodfill mask image to get valid size to match correct pacth (possible plate).
10. Apply "getRotationMatrix2D" and warpAffine funciton to remove possible rotations in the detected regions.
11. Apply "getRectSubPix" which crops and copies image of given size centered at given point.
12. Cropped images are not good for training and detection because of different size, different light conditions and relative difference. We resize all the cropped to same width and height (144,33) and apply histogram equalization.  

**Classification:**  
In this step we decide whether a detected region is number plate or not using SVM (Support vector machine).

Before using SVM classifier, we need to train our system. I used 48 german number plates and 29 non number plate images of 144x33 pixels to train system.
I have stored all training image's data into SVM.xml using "FileStorage" class of openCV which manages a data file in XML or JSON format.

###Plate recognition
I will work on this step tomorrow. This step includes OCR training and OCR segmentation, Feature detection and OCR classification.



















