# German ANPR 

####Characteristics of German number plate.

| Feature       | Description   |   
| ------------- |:-------------:| 
| Plate Size    | 520x112 (mm)	 | 
| Font		     | FE-Schrift (“fälschungserschwerende Schrift”, tamper-hindering script)|
| Max Characters | 8	 |  
| Background color | White	 |  
| Font color | Black	 |  
| Border color | Black	 |  


#### ANPR Steps
1. Plate Detection
	 * Plate Localization	
	 * Segmentation
	 * Classification
* Plate Recognition
	 * OCR Segmentation
	 * Feature Extraction
	 * OCR Classification
	 * Evaluation

##1. Plate detection
	This steps finds the number plate in the provided image. There are many steps involved that do the specific serving.

#### 1.1 Plate Localization:
In plate localization, we find the candidate regions that may contain a license plate.  
Then we apply some filters on found regions with various parameters.  
Then we adjust the plate position in filtered regions.
	
	(**Note:** All operations in openCV are performed on grayscale images)

	1. Convert input image to grayscale. 
	2. Apply Gaussian blur with 5x5 mask to remove noise.
	3. Apply Sobel operator to find edges.
	4. Apply Otsu's thresholding to determine optimal threshold value and obtain binary image.
	5. Apply Close morphological operation to connect all vertical edges.
	
#### 1.2 Segmentation:


	1. Findcontours function to split into possible plate regions.
	2. Iterate through obtained regions to get bounding rectangle of minimal area.
	3. Apply floodfill operation to obtain mask image to store possible croping region. 
	4. Use floodfill mask image to get valid size to match correct pacth (possible plate).
	5. Apply "getRotationMatrix2D" and warpAffine funciton to remove possible rotations in the detected regions.
	6. Apply "getRectSubPix" which crops and copies image of given size centered at given point.
	7. Resize cropped images to 144x33 as cropped images are not good for training and detection because of different size, different light conditions and relative difference. 
	8. Apply histogram equalization to cropped images.  

#### 1.3 Classification:
	In this step we decide whether a detected region is number plate or not using SVM (Support vector machine).
	Before using SVM classifier, we need to train our system. We used 48 german number plates and 29 non number plate images of 144x33 pixels to train system.
	We have stored all training image's data into SVM.xml using "FileStorage" class of openCV which manages a data file in XML or JSON format.

###Plate recognition
We will work on this step tomorrow. This step includes OCR training and OCR segmentation, Feature detection and OCR classification.



















