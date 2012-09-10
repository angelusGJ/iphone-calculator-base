//
//  CalculatorViewController.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorAmazon.h"
#import "CalculatorComunicatorAmazon.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString  * const ZERO = @"0";

@implementation CalculatorViewController

@synthesize display;
@synthesize firstOperand;
@synthesize operator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    calculator = [[CalculatorAmazon alloc] initWithComunicator:[[CalculatorComunicatorAmazon alloc] init]];
    ((CalculatorAmazon *)calculator).delegate = self;
    display.text = ZERO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    display = nil;
    calculator = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)buttonNumberPressed:(id)sender {
    UIButton * button = (UIButton *)sender;
    NSString * number = [[button titleLabel] text];
    
    if ([[display text] isEqualToString:ZERO]) {
        display.text = number;
    } else {
        display.text = [[display text] stringByAppendingString: number];
    }
}

- (void)deleteButtonPressed:(id)sender {
    NSString *number = [display text];
    
    if (number.length == 1) {
        display.text = ZERO;
    } else {
        display.text = [number substringToIndex:([number length] - 1)];
    }
}

- (void)resetButtonPressed:(id)sender {
    display.text = ZERO;
    firstOperand = nil;
    operator = nil;
}

- (void) operationButtonPressed:(id)sender {
    UIButton * button = (UIButton *)sender;
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    
    firstOperand = [formater numberFromString:display.text];
    display.text = ZERO;
    operator = [[button titleLabel] text];
    
}

- (void)equalButtonPressed:(id)sender {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *secondOperand = [formater numberFromString:display.text];

    if ([operator isEqualToString:@"-"]) {
        [calculator subtract:firstOperand subtrahend: secondOperand];
    } else if ([operator isEqualToString:@"+"]) {
        [calculator add:firstOperand secondSummand:secondOperand];
    } else if ([operator isEqualToString:@"/"]) {
        [calculator divide:firstOperand divisor:secondOperand];
    } else if ([operator isEqualToString:@"*"]) {
        [calculator multiply:firstOperand secondFactor:secondOperand];
    }
    
    [self showWaitingModalPanel];
}

- (void)didFinishOperation:(NSNumber *)result {
    display.text = [result stringValue];
    [self hideWaitingModalPanel];

}

- (void)didFinishOperationWithError:(NSError *)error {
    [self hideWaitingModalPanel];
    [self showMessageError];
}

- (void) showWaitingModalPanel {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) hideWaitingModalPanel {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) showMessageError {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"The operation can not be executed." delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    
    [alert show];
    
}

@end
