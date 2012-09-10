//
//  CalculatorViewController.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"
#import "CalculatorDelegate.h"

@interface CalculatorViewController : UIViewController<CalculatorDelegate> {
@protected
    id<Calculator> calculator;
    UITextField *display;
    NSNumber *firstOperand;
    NSString *operator;

}

@property (strong, nonatomic) IBOutlet UITextField *display;
@property (readonly, nonatomic) NSNumber *firstOperand;
@property (readonly, nonatomic) NSString *operator;

- (IBAction) buttonNumberPressed:(id)sender;
- (IBAction) deleteButtonPressed:(id)sender;
- (IBAction) resetButtonPressed:(id)sender;
- (IBAction) operationButtonPressed:(id)sender;
- (IBAction) equalButtonPressed:(id)sender;
@end
