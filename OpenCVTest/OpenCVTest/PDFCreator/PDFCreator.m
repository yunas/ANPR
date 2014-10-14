//
//  PDFCreator.m
//  LNPR
//
//  Created by Yunas Qazi on 10/3/14.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "PDFCreator.h"

@interface PDFCreator(private)

- (void) generatePdfWithFilePath: (NSString *)thefilePath;
- (void) drawPageNumber:(NSInteger)pageNum;
- (void) drawBorder;
- (void) drawText :(NSString *)textToDraw;
- (void) drawLine;
- (void) drawHeader;
- (void) drawImage;

@end

@implementation PDFCreator


#pragma mark - Private Methods
- (void) drawBorder
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    UIColor *borderColor = [UIColor brownColor];
    
    CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, pageSize.width-kBorderInset*2, pageSize.height-kBorderInset*2);
    
    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, kBorderWidth);
    CGContextStrokeRect(currentContext, rectFrame);
}

- (void)drawPageNumber:(NSInteger)pageNumber
{
    NSString* pageNumberString = [NSString stringWithFormat:@"Page %ld", (long)pageNumber];
    UIFont* theFont = [UIFont systemFontOfSize:17.0];
    
    CGSize pageNumberStringSize = [pageNumberString sizeWithAttributes:
                                                 @{NSFontAttributeName:theFont}];
    
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            pageSize.height - 40.0,
                                            pageSize.width - 2*kBorderInset,
                                            pageNumberStringSize.height);
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictionary = @{ NSFontAttributeName: theFont,
                                  NSParagraphStyleAttributeName: textStyle,
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [pageNumberString drawInRect:stringRenderingRect withAttributes:dictionary];
    
}

- (void) drawHeader
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.3, 0.7, 0.2, 1.0);
    
    NSString *textToDraw = @"Report LNPR";
    
    UIFont* theFont = [UIFont systemFontOfSize:24.0];
    
    CGSize stringSize = [textToDraw sizeWithAttributes:
                                   @{NSFontAttributeName:theFont}];

    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset,
                                      kBorderInset + kMarginInset,
                                      pageSize.width - 2*kBorderInset - 2*kMarginInset,
                                      stringSize.height);
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictionary = @{ NSFontAttributeName: theFont,
                                  NSParagraphStyleAttributeName: textStyle,
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [textToDraw drawInRect:renderingRect withAttributes:dictionary];}

- (void) drawText:(NSString *)textToDraw ForColumn:(int)columnNumber forRow:(int)rowNumber
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    UIFont* theFont = [UIFont systemFontOfSize:14.0];
    
    CGSize stringSize = [textToDraw sizeWithAttributes:
                         @{NSFontAttributeName:theFont}];
    
    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset + (200.0 *columnNumber) ,
                                      kBorderInset + kMarginInset + 2 + (20.0 *rowNumber) + 20,
                                      200,
                                      stringSize.height);
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictionary = @{ NSFontAttributeName: theFont,
                                  NSParagraphStyleAttributeName: textStyle,
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [textToDraw drawInRect:renderingRect withAttributes:dictionary];
    
}

- (void) drawLine
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    
    CGPoint startPoint = CGPointMake(kMarginInset + kBorderInset, kMarginInset + kBorderInset + 60.0);
    CGPoint endPoint = CGPointMake(pageSize.width - 2*kMarginInset -10 , kMarginInset + kBorderInset + 60.0);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void) drawImage
{
    UIImage * demoImage = [UIImage imageNamed:@"demo.png"];
    [demoImage drawInRect:CGRectMake( (pageSize.width - demoImage.size.width/2)/2, 350, demoImage.size.width/2, demoImage.size.height/2)];
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath withArray:(NSArray*)reportsArr
{
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    NSInteger currentPage = 0;
    BOOL done = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //Draw a page number at the bottom of each page.
        currentPage++;
        [self drawPageNumber:currentPage];
        
        //Draw a border for each page.
        [self drawBorder];
        
        //Draw text fo our header.
        [self drawHeader];
        
        //Draw a line below the header.
        [self drawLine];

        [self drawText:@"Expected"  ForColumn:0 forRow:1];
        [self drawText:@"Observed"  ForColumn:1 forRow:1];
        [self drawText:@"Status"    ForColumn:2 forRow:1];
        
        int row = 2;
        for (NSDictionary *report in reportsArr) {
            //Draw some text for the page.
            [self drawText:report[@"Expected"]  ForColumn:0 forRow:row];
            [self drawText:report[@"Observed"]  ForColumn:1 forRow:row];
            [self drawText:report[@"Status"]    ForColumn:2 forRow:row];
            row++;
        }
        
//        //Draw an image
//        [self drawImage];
        done = YES;
    }
    while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

#pragma mark - View lifecycle

- (NSString*) generatePdf:(NSArray*)reportsArr
{
    pageSize = CGSizeMake(612, 792);
    NSString *fileName = @"Report.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [self generatePdfWithFilePath:pdfFileName withArray:reportsArr];
  
    return pdfFileName;
}

@end
