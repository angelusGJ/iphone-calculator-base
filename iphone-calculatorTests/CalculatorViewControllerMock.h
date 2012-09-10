//
//  CalculatorViewControllerMock.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 28/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "Calculator.h"
#import "CalculatorViewController.h"

@interface CalculatorViewControllerMock : CalculatorViewController
- (id<Calculator>) currentCalculator;
- (void) setCurrentCalculator: (id<Calculator>) newCalculator;
- (void) setFirstOperand:(NSNumber *) newFirstOperand;
- (void) setOperator:(NSString *)newOperator;
- (void) showWaitingModalPanel;
- (void) hideWaitingModalPanel;
@end



