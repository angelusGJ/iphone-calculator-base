//
//  CalculatorDelegate.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CalculatorDelegate <NSObject>
- (void) didFinishOperationWithError:(NSError *)error;
- (void) didFinishOperation:(NSNumber*) result;
@end
