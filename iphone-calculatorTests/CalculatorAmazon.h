//  CalculatorAmazon.h
//
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 24/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator.h"
#import "CalculatorComunicator.h"
#import "CalculatorDelegate.h"

@interface CalculatorAmazon : NSObject <Calculator, CalculatorComunicatorDelegate>
- (id) initWithComunicator:(id<CalculatorComunicator>) newComunicator;
@property (readonly) id<CalculatorComunicator> comunicator;
@property (assign) id<CalculatorDelegate> delegate;
@end

extern NSString *CalculatorErrorDomain;
