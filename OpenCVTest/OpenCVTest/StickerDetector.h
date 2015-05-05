//
//  Sticker.h
//  LNPR
//
//  Created by Muhammad Rashid on 04/05/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickerDetector : NSObject

+(cv::Mat) removeStickerFromPlate:(UIImage*)plateImg;

@end
