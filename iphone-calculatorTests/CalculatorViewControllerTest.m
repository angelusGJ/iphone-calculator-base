//
//  CalculatorViewControllerTest.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorViewControllerMock.h"
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@interface CalculatorViewControllerTest : SenTestCase{
    CalculatorViewController *controller;
    CalculatorViewControllerMock *controllerMock;
    id calculator;
}
@end

@implementation CalculatorViewControllerTest

- (void)setUp {
    controller = [[CalculatorViewController alloc] init];
    controller.display = [[UITextField alloc] init];
    [controller viewDidLoad];
    
    calculator = [OCMockObject mockForProtocol:@protocol(Calculator)];
    controllerMock = [[CalculatorViewControllerMock alloc] init];
    
    controllerMock.display = [[UITextField alloc] init];
    [controllerMock viewDidLoad];    
    [controllerMock setCurrentCalculator: calculator];

}

- (void)tearDown {
    controller = nil;
}
- (void) testCalculatorHasADisplayToShowResults {
    
    STAssertNotNil([controller display], @"Calculator has a display to show results");
}

- (void) testDisplayHasZeroWhenViewIsCreated {
    
    [self assertDisplayWithValue:@"0" description:@"Display show zero when start the view."];
}

- (void) testShowOneInDisplayWhenButtonWithNameOneIsPressed {
    UIButton * one = [self createButtonWithLabel:@"1"];
    
    [controller buttonNumberPressed:one];
    
    [self assertDisplayWithValue: @"1" description:@"Display should show one."];
}

- (void) testShowTwoInDisplayWhenButtonWithNameTwoIsPressed {
    UIButton * two = [self createButtonWithLabel:@"2"];
    
    [controller buttonNumberPressed:two];
    
    [self assertDisplayWithValue: @"2" description:@"Display should show two."];
}

- (void) testShowElevenWhenDisplayHasOneAndOneButtonIsPressed {
    UIButton * one = [self createButtonWithLabel:@"1"];

    controller.display.text = @"1";

    [controller buttonNumberPressed:one];
    
    [self assertDisplayWithValue: @"11" description:@"Display should show eleven."];
}

- (UIButton *) createButtonWithLabel:(NSString*) label {
    UIButton * button = [[UIButton alloc] init];
    
    button.titleLabel.text = label;
    
    return button;
}

- (void) testShouldRemoveLastDigitOfDisplayWhenDeleteButtonIsPressed {
    
    controller.display.text = @"12345";
    [controller deleteButtonPressed:nil];
    
    [self assertDisplayWithValue: @"1234" description:@"Should remove last digit when deleteButton is pressed"];
}
-(void) testDisplayIsZeroWhenDeleteButtonIsPressedAndDisplayHasOneDigit {
    controller.display.text = @"1";
    
    [controller deleteButtonPressed:nil];
    
    [self assertDisplayWithValue: @"0" description:@"Display should show zero when last number is deleted"];

}

- (void) testShouldResetCalculatorWhenCButtonIsPressed {
    controller.display.text = @"12345";
    [controller resetButtonPressed:nil];
    
    [self assertDisplayWithValue: @"0" description:@"Display should be zero."];
    STAssertNil(controller.firstOperand, @"First Operand should be nil");
    STAssertNil(controller.operator, @"Operator should be nil");
}

- (void) assertDisplayWithValue:(NSString *) value description:(NSString *) description {
    STAssertEqualObjects([[controller display] text], value, description);
}

- (void) testFirstOperandIsSavedWhenAnyOperationButtonisPressed {
    UIButton * plus = [self createButtonWithLabel:@"+"];
    controller.display.text = @"12345";
    
    [controller operationButtonPressed:plus];
    
    STAssertEqualObjects(controller.firstOperand, [NSNumber numberWithDouble:12345], @"First operand is saved when any operation button is pressed");
}

- (void) testOperatorIsSavedWhenAnyOperationButtonisPressed {
    UIButton * minus = [self createButtonWithLabel:@"-"];
    
    [controller operationButtonPressed:minus];
    
    STAssertEqualObjects(controller.operator, @"-", @"Operator is saved when any operation button is pressed");
    
}

- (void) testDesplaySetZeroWhenAnyOperationButtonisPressed {
    UIButton * minus = [self createButtonWithLabel:@"-"];
    
    [controller operationButtonPressed:minus];
    
    [self assertDisplayWithValue:@"0" description:@"Display should show zero when operation button is pressed"];
}


- (void) testCalculatorServiceCanNotBeNilWhenViewIsCreated {
    CalculatorViewControllerMock *controllerMockWithCalculator = [[CalculatorViewControllerMock alloc] init];
    
    [controllerMockWithCalculator viewDidLoad];
    
    STAssertNotNil([controllerMockWithCalculator currentCalculator], @"Calculator can not be nil when view is created");
}

- (void) testShouldCalculateOperationWhenEqualIsPressed {
    [self stubOperationWithFisrtOperand:@2 operator:@"+" display:@"2"];

    [[calculator expect] add:@2 secondSummand:@2];
    [controllerMock equalButtonPressed:nil];
    
    [calculator verify];
}

- (void) testShouldSubtractWhenEqualsIsPressedAndOperatorIsMinus {
    [self stubOperationWithFisrtOperand:@2 operator:@"-" display:@"2"];
    
    [[calculator expect] subtract:@2 subtrahend:@2];    
    [controllerMock equalButtonPressed:nil];
    
    [calculator verify];

}

- (void) testShouldDivideWhenEqualsIsPressedAndOperatorIsSlash {
    [self stubOperationWithFisrtOperand:@2 operator:@"/" display:@"2"];
    
    [[calculator expect] divide:@2 divisor:@2];
    [controllerMock equalButtonPressed:nil];
    
    [calculator verify];
    
}

- (void) testShouldMultipleWhenEqualsIsPressedAndOperatorIsAsterisk {
    [self stubOperationWithFisrtOperand:@2 operator:@"*" display:@"2"];
    
    [[calculator expect] multiply:@2 secondFactor:@2];
    [controllerMock equalButtonPressed:nil];
    
    [calculator verify];
    
}

- (void) stubOperationWithFisrtOperand:(NSNumber *)firstOperand operator:(NSString *) operator display:(NSString *) display {
    [controllerMock setFirstOperand:firstOperand];
    [controllerMock setOperator:operator];
    controllerMock.display.text = display;
}

- (void) testShowTheResultInDisplayWhenReceiveAResponseSucessful {
    id controllerPartialMock = [OCMockObject partialMockForObject:controller];
    
    [[controllerPartialMock expect] hideWaitingModalPanel];
    [controllerPartialMock didFinishOperation:@2];
    
    STAssertEqualObjects([[controllerPartialMock display] text], @"2", @"Display should show the result of operation");
}

- (void) testShouldShowModalPanelWhenInvokeTheCalculator {
    [self stubOperationWithFisrtOperand:@2 operator:@"*" display:@"2"];
    id controllerPartialMock = [OCMockObject partialMockForObject:controllerMock];
    
    [[calculator expect] multiply:@2 secondFactor:@2];
    [[controllerPartialMock expect] showWaitingModalPanel];
    
    [controllerPartialMock equalButtonPressed:nil];

    [controllerPartialMock verify];
    
}

- (void) testShouldHideModalPanelWhenReceiveSucessfullResponse {
    id controllerPartialMock = [OCMockObject partialMockForObject:controllerMock];
    
    [[controllerPartialMock expect] hideWaitingModalPanel];
    
    [controllerPartialMock didFinishOperation:@2];
    
    [controllerPartialMock verify];
    
}

- (void) testShouldHideModalPanelWhenReceiveResponseWithError {
    id controllerPartialMock = [OCMockObject partialMockForObject:controllerMock];
    
    [[controllerPartialMock expect] hideWaitingModalPanel];
    
    [controllerPartialMock didFinishOperationWithError:nil];
    
    [controllerPartialMock verify];
    
}

@end
