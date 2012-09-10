//
//  CalculatorComunicatorDelegate.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CalculatorComunicatorDelegate <NSObject>

- (void) resultOperationFailedWithError:(NSError *)error;
- (void) resultOperation:(NSString *) resultJSON;
@end
