//
//  PDFCreator.h
//  LNPR
//
//  Created by Yunas Qazi on 10/3/14.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            10.0

//Line drawing
#define kLineWidth              1.0



@interface PDFCreator : NSObject
{
    CGSize pageSize;
}

- (void)generatePdf:(NSArray*)reportsArr;



@end
