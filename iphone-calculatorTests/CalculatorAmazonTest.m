//
//  CalculatorAmazonTest.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 24/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "CalculatorAmazon.h"
#import <SenTestingKit/SenTestingKit.h>

@interface CalculatorAmazonTest : SenTestCase {
@private
    CalculatorAmazon * calculator;
    id comunicator;
}
@end


@implementation CalculatorAmazonTest


- (void) setUp {
    comunicator = [OCMockObject niceMockForProtocol:@protocol(CalculatorComunicator)];
    calculator = [[CalculatorAmazon alloc] initWithComunicator:(id<CalculatorComunicator>) comunicator];
}

- (void) tearDown {
    comunicator = nil;
    calculator = nil;
}

- (void) testShouldGetTheResultOfAmazonServiceWhenAddTwoNumbers {
    [self setUpMockComunicator:@2 secondOperand:@2 operator:ADD];
    
    [calculator add:@2 secondSummand:@2];
    
    [comunicator verify];
}

- (void) testShouldGetTheResultOfAmazonServiceWhenSubtractTwoNumbers {
   [self setUpMockComunicator:@2 secondOperand:@2 operator:SUBSTRACT];
    
    [calculator subtract:@2 subtrahend:@2];
    
    [comunicator verify];
}

- (void) testShouldGetTheResultOfAmazonServiceWhenMultipleTwoNumbers {
    [self setUpMockComunicator:@2 secondOperand:@2 operator:MULTIPLY];
    
    [calculator multiply:@2 secondFactor:@2];
    
    [comunicator verify];
}

- (void) testShouldGetTheResultOfAmazonServiceWhenDivideTwoNumbers {
    [self setUpMockComunicator:@2 secondOperand:@2 operator:DIVIDE];
    
    [calculator divide:@2 divisor:@2];
    
    [comunicator verify];
}

- (void) testCalculatorComunicatorCanNotBeNil {
    STAssertThrows(comunicator = [[CalculatorAmazon alloc] initWithComunicator:nil], @"comunicator can not be null");
}

- (void) testThrowExceptionIfComunicatorObjectNoConformingProtocol {
    id<CalculatorComunicator> nullComunicator = (id<CalculatorComunicator>)[NSNull null];
    STAssertThrows(comunicator = [[CalculatorAmazon alloc] initWithComunicator: nullComunicator], @"object no conform the protocol comunicator");
}


- (void) testSetDelegateComunicatorWhenInitCalculatorForManagingTheOperationResult {
    
    [[comunicator expect] setDelegate:[OCMArg isNotNil]];
    
    [[CalculatorAmazon alloc] initWithComunicator:comunicator];
    
    [comunicator verify];
    
}

- (void) setUpMockComunicator:(NSNumber *) firstOperand secondOperand:(NSNumber *) secondOperand operator:(enum Operator) operator {
    [[comunicator expect] fetchingResult:firstOperand secondOperand:secondOperand operator:operator];    
}

- (void) testReceiveOperationFailedWithErrorPassesToDelegate {
    id error = [OCMockObject mockForClass:[NSError class]];
    id delegate = [OCMockObject mockForProtocol:@protocol(CalculatorDelegate)];

    calculator.delegate= delegate;
    [[delegate expect] didFinishOperationWithError:error];
    
    [calculator resultOperationFailedWithError:error];
    
    [delegate verify];
}

- (void) testReceiveSuccesfulOperationPassesToDelegate {
    id delegate = [OCMockObject mockForProtocol:@protocol(CalculatorDelegate)];
    
    calculator.delegate= delegate;
    
    [[delegate expect] didFinishOperation:@345];
    
    [calculator resultOperation:@"{\"result\": 345}"];
    
    [delegate verify];
}


@end
