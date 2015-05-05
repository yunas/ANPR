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

- (NSUInteger)numberOfOccurencesOfSubstring:(NSString *)substring inString:(NSString*)string
{
    NSArray *components = [string componentsSeparatedByString:substring];
    return components.count - 1; // Two substring will create 3 separated strings in the array.
}

-(NSString *) stringBySplitingInTwoComponents:(NSString*)str{
    NSString *splittedStr = [NSString stringWithString:str];
    
    
    if([self numberOfOccurencesOfSubstring:@" " inString:splittedStr] <= 0){
        if(str.length >= 3){
            
            int center = ceil(str.length/2.0);
            
            NSString *firstStr = [str substringToIndex:center];
            NSString *secondStr = [str substringWithRange:NSMakeRange(center, str.length - center)];
            
            splittedStr = [NSString stringWithFormat:@"%@ %@",firstStr,secondStr];
            
        }
    }
    
    return splittedStr;
}

-(NSString *) stringWithoutStickerText:(NSString*)str{
    NSString *filteredStr = [NSString stringWithString:str];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"3" withString:@" "];
    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"8" withString:@" "];
//    filteredStr = [filteredStr stringByReplacingOccurrencesOfString:@"S" withString:@" "];
    
    NSArray *partaArr = [filteredStr componentsSeparatedByString:@" "];
    NSString *parta = @"";
    if (partaArr.count > 0) {
        parta = [self stringWithAlphabetsOnly:partaArr[0]];
    }
    
    for (int i=1 ; i < partaArr.count; i++) {
        NSString *pStr = partaArr[i];
        parta = [NSString stringWithFormat:@"%@ %@",parta,[self stringWithAlphabetsOnly:pStr]];
    }

    return parta;
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

    NSString *filteredStr = [NSString stringWithString:[self filterExtraSpaces:ocrText]];

    filteredStr = [self stringWithoutPunctuations:filteredStr];

    NSArray *platesPart = [filteredStr componentsSeparatedByString:@" "];

    if (platesPart.count == 3) {
        NSString *parta = [self stringWithAlphabetsOnly:platesPart[0]];
        NSString *partb = [self stringWithAlphabetsOnly:platesPart[1]];
        NSString *partc = [self stringWithNumbersOnly:platesPart[2]];
        filteredStr = [NSString stringWithFormat:@"%@ %@ %@",parta,partb,partc];
    }
    else if (platesPart.count == 2) {
        NSString *parta = [self stringWithoutStickerText:platesPart[0]];
        parta = [self stringBySplitingInTwoComponents:parta];
        NSString *partb = platesPart[1];//[self stringWithNumbersOnly:platesPart[1]];
        filteredStr = [NSString stringWithFormat:@"%@ %@",parta,partb];
    }

    return filteredStr;
}

- (NSString *)filterExtraSpaces:(NSString *)text {

    NSString *trimmed = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedString = [regex stringByReplacingMatchesInString:trimmed options:0 range:NSMakeRange(0, [trimmed length]) withTemplate:@" "];
    return trimmedString;
}


@end
