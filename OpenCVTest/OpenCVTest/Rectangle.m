//
//  Rectangle.m
//  LNPR
//
//  Created by Muhammad Rashid on 05/03/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import "Rectangle.h"

static Rectangle *obj;

@interface Rectangle()
@property (nonatomic) CGFloat lineWidth;

@end

@implementation Rectangle {
    CGFloat aspectRaatio;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = 2.0f;
        self.userInteractionEnabled = NO;
        self.tag = 420;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];

    CGRect rectViewFrame = rect;

    if (CGRectGetWidth(rect)== CGRectGetWidth([UIScreen mainScreen].bounds)) {
        rectViewFrame = CGRectInset(rect, rect.size.width*0.32, rect.size.height*0.43);
    }

    CGRect subRect = CGRectInset(rectViewFrame, _lineWidth, _lineWidth);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextStrokeRectWithWidth(context, subRect, _lineWidth);
}


+ (void)showCameraFocusRectangleInView:(UIView *)view {

    CGRect frame = [UIScreen mainScreen].bounds;

    Rectangle *rectangle = [[Rectangle alloc] initWithFrame:frame];
    obj = rectangle;
    [UIView transitionWithView:view
                      duration:0.2
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{  [view addSubview:rectangle]; }
                    completion:NULL];
}

+ (void)hideCameraFocusRectangle {

    [UIView transitionWithView:obj.superview
                      duration:0.2
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{ [obj removeFromSuperview]; obj = nil; }
                    completion:NULL];
}

@end
