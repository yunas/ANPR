//
//  UIImage+operation.h
//  ANPR
//
//  Created by Christian Roman on 29/08/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UKImage)

- (UIImage*)rotate:(UIImageOrientation)orientation;
- (UIImage *)scaleImageKeepingAspectRatiotoSize:(CGSize)newSize;
- (UIImage*)scaleImageToRatina:(CGSize)newSize;
- (UIImage *)scaleImageToSize:(CGSize)newSize;
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage*)resizeImageToWidth:(CGFloat)width;
@end

