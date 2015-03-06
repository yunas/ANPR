//
//  UItility.h
//  LNPR
//
//  Created by Muhammad Rashid on 04/03/2015.
//  Copyright (c) 2015 Muhammad Rashid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (instancetype) sharedInstance;
- (NSString *) filterPlateNumberFromOCRString:(NSString *)ocrText;
@end
