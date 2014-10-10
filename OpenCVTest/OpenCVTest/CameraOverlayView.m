//
//  CameraOverlayView.m
//  LNPR
//
//  Created by Muhammad Rashid on 09/10/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView

+ (CameraOverlayView *)loadFromNib {
    
    CameraOverlayView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}
@end
