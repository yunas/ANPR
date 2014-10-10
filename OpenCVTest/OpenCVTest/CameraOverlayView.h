//
//  CameraOverlayView.h
//  LNPR
//
//  Created by Muhammad Rashid on 09/10/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraOverlayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIImageView *canvesView;

+ (CameraOverlayView *)loadFromNib;

@end
