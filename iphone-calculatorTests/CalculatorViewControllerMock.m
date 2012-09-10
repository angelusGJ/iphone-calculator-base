//
//  CalculatorViewControllerMockViewController.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 28/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorViewControllerMock.h"


@implementation CalculatorViewControllerMock

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id<Calculator>)currentCalculator {
    return calculator;
}

- (void)setCurrentCalculator:(id<Calculator>)newCalculator {
    calculator = newCalculator;
}

- (void)setFirstOperand:(NSNumber *)newFirstOperand {
    firstOperand = newFirstOperand;
}

- (void)setOperator:(NSString *)newOperator {
    operator = newOperator;
}
@end
