//
//  CalculatorAmazon.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 24/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorAmazon.h"


@implementation CalculatorAmazon

@synthesize comunicator;
@synthesize delegate;

-(id) initWithComunicator:(id<CalculatorComunicator>)newComunicator {

    NSParameterAssert(newComunicator);

    if (newComunicator && ![newComunicator conformsToProtocol:@protocol(CalculatorComunicator)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Comunicator objec does not conform the protocol CalculatorComunicator" userInfo:nil] raise];
    }
    
    
    if (self = [super init]) {
        comunicator = newComunicator;
        [comunicator setDelegate:self];
    }
    
    return self;
    
}

- (void) add:(NSNumber *)firstSummand secondSummand:(NSNumber *)secondSummand {
    [comunicator fetchingResult:firstSummand secondOperand:secondSummand operator:ADD];
}

- (void) multiply:(NSNumber *)firstFactor secondFactor:(NSNumber *)secondFactor {
    [comunicator fetchingResult:firstFactor secondOperand:secondFactor operator:MULTIPLY];
}

- (void) subtract:(NSNumber *)minuend subtrahend:(NSNumber *)subtrahend {
    [comunicator fetchingResult:minuend secondOperand:subtrahend operator:SUBSTRACT];
}

- (void)divide:(NSNumber *)dividend divisor:(NSNumber *)divisor {
    [comunicator fetchingResult:dividend secondOperand:divisor operator:DIVIDE];
}

#pragma Deletegate AmazonComunicator

- (void)resultOperationFailedWithError:(NSError *)error {
    [delegate didFinishOperationWithError:error];
}

- (void)resultOperation:(NSString *)resultJSON {
    NSData *unicodeNotation = [resultJSON dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
    
    NSDictionary *parsedObject = (id)jsonObject;
    
    if (parsedObject == nil) {
        [delegate didFinishOperationWithError:localError];
    }
    @try {
        NSNumber *result = [parsedObject objectForKey: @"result"];
        [delegate didFinishOperation: result];
    }
    @catch (NSException *exception) {
        NSError *error = [NSError errorWithDomain:CalculatorErrorDomain code:-1 userInfo:[exception userInfo]];
        [delegate didFinishOperationWithError:error];
    }
}
@end

NSString *CalculatorErrorDomain = @"CalculatorErrorDomain";
        