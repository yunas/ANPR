//
//  CameraView.h
//  LNPR
//
//  Created by Muhammad Rashid on 10/10/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(UIImage *img);

@interface CameraView : UIView

@property (nonatomic, readonly) CGRect selfFrame;
@property (nonatomic, assign) CGRect canvasFrame;
@property (nonatomic, copy) CompletionBlock block;

- (instancetype)initWithFrame:(CGRect)frame completionBlovk:(CompletionBlock)blk;
@end

