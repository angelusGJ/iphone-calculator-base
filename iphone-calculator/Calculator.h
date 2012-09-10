//
//  Calculator.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 25/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Calculator <NSObject>
- (void) add:(NSNumber*)firstSummand secondSummand: (NSNumber *) secondSummand;
- (void) multiply:(NSNumber*)firstFactor secondFactor: (NSNumber *) secondFactor;
- (void) subtract:(NSNumber*)minuend subtrahend: (NSNumber *) subtrahend;
- (void) divide:(NSNumber*)dividend divisor: (NSNumber *) divisor;
@end
