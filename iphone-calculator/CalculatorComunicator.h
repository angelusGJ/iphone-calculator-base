//
//  CalculatorComunicator.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 26/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorComunicatorDelegate.h"

enum Operator {ADD = 1, SUBSTRACT = 2, DIVIDE = 3, MULTIPLY = 4};

@protocol CalculatorComunicator <NSObject>
@property (assign) id<CalculatorComunicatorDelegate> delegate;
- (void) fetchingResult:(NSNumber *) firstOperand secondOperand: (NSNumber *) secondOperand operator: (enum Operator) operator;

@end
