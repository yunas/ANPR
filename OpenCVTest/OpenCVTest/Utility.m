//
//  UItility.m
//  LNPR
//
//  Created by Muhammad Rashid on 04/03/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (instancetype) sharedInstance {
    static Utility *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [Utility new];
    });
    return obj;
}

#pragma mark - String Filtering

-(NSString *) stringWithNumbersOnly:(NSString*)str{

    NSString *numberStr = [NSString stringWithString:str];

    numberStr = [numberStr stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [numberStr length])];
    if (numberStr.length >= 5) {
        numberStr = [numberStr substringToIndex:4];
    }

    return numberStr;

}

-(NSString *) stringWithAlphabetsOnly:(NSString *)str{
    NSString *alphaStr = [NSString stringWithString:str];
    alphaStr = [alphaStr stringByReplacingOccurrencesOfString:@"[^A-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [alphaStr length])];
    return alphaStr;
}

-(NSString *) stringWithoutPunctuations:(NSString *)str{
    NSString *filteredStr = [NSString stringWithString:str];
    filteredStr = [filteredStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"[^A-Z0-9 ]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [filteredStr length])];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"•" withString:@" "];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"  " withString:@" "];

    return filteredStr;
}

- (NSString *) filterPlateNumberFromOCRString:(NSString *)ocrText {

    NSString *filteredStr = [NSString stringWithString:ocrText];

    filteredStr = [self stringWithoutPunctuations:filteredStr];

    NSArray *platesPart = [filteredStr componentsSeparatedByString:@" "];

    if (platesPart.count == 3) {
        NSString *parta = [self stringWithAlphabetsOnly:platesPart[0]];
        NSString *partb = [self stringWithAlphabetsOnly:platesPart[1]];
        NSString *partc = [self stringWithNumbersOnly:platesPart[2]];
        filteredStr = [NSString stringWithFormat:@"%@ %@ %@",parta,partb,partc];
    }
    else if (platesPart.count == 2) {
        NSString *parta = [self stringWithAlphabetsOnly:platesPart[0]];
        NSString *partb = platesPart[1];//[self stringWithNumbersOnly:platesPart[1]];
        filteredStr = [NSString stringWithFormat:@"%@ %@",parta,partb];
    }

    return filteredStr;
}


@end
