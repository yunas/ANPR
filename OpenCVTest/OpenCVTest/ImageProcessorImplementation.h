//
//  ImageProcessor.h
//  OpenCVTest
//
//  Created by Muhammad Rashid on 08/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageProcessorImplementation : NSObject

+ (UIImage *)getLocalisedImageFromSource:(UIImage*)src imageName:(NSString*)name;

- (UIImage*)LocalizeImageFromSource:(UIImage *)image;

- (UIImage*)dilationOfSource:(UIImage *)src;
- (UIImage*)erosionOfSource:(UIImage *)src;

@end
