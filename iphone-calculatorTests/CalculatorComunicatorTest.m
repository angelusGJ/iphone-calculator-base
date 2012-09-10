//
//  CalculatorComunicatorTest.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "CalculatorComunicatorAmazon.h"
#import "CalculatorComunicatorMock.h"

@interface CalculatorComunicatorTest : SenTestCase {
@private
    CalculatorComunicatorMock *comunicatorMock;
    id delegate;
}
@end

@implementation CalculatorComunicatorTest


- (void) setUp {
    comunicatorMock = [[CalculatorComunicatorMock alloc] init];
    delegate = [OCMockObject mockForProtocol:@protocol(CalculatorComunicatorDelegate)];
    comunicatorMock.delegate = delegate;

}

- (void) tearDown {
    comunicatorMock = nil;
    delegate = nil;
}

- (void) testDelegateCanNotBeNil {
    
    STAssertThrows(comunicatorMock.delegate = nil, @"Deletage can not be nil");
}

- (void) testTrhowExceptionIfDelegateObjectDoesNotConformTheProtocol {
    
    STAssertThrows(comunicatorMock.delegate =(id<CalculatorComunicatorDelegate>) [NSNull null], @"delegate object does not conform the correct protocol");
    
}


- (void) testShouldInvokeTheAmazonURLServiceWhenFecthResultAdd {
    
    
    [comunicatorMock fetchingResult:@2 secondOperand:@1 operator:ADD];
    
    [self assertURLService:@2 secondOperand:@1 operator:ADD];
}

- (void) testShouldInvokeTheAmazonURLServiceWhenFecthResultSubtract {

    
    [comunicatorMock fetchingResult:@4 secondOperand:@2 operator:SUBSTRACT];
    
    [self assertURLService:@4 secondOperand:@2 operator:SUBSTRACT];
    
}

- (void) testShouldInvokeTheAmazonURLServiceWhenFecthResultDivide {

    
    [comunicatorMock fetchingResult:@4 secondOperand:@2 operator:DIVIDE];
    
    [self assertURLService:@4 secondOperand:@2 operator:DIVIDE];
}

- (void) testShouldInvokeTheAmazonURLServiceWhenFecthResultMultiply {
    
    [comunicatorMock fetchingResult:@4 secondOperand:@2 operator:MULTIPLY];
    [self assertURLService:@4 secondOperand:@2 operator:MULTIPLY];
}

- (void) assertURLService:(NSNumber *) firstOperand secondOperand:(NSNumber *) secondOperand operator:(enum Operator) operator {
    NSString *url = [NSString stringWithFormat:@"http://ec2-54-247-37-1.eu-west-1.compute.amazonaws.com:8080/demo-ws-spring-mvc/rest/calc/%.02f/%.02f/%d", [firstOperand doubleValue], [secondOperand doubleValue], operator];
        
    
    STAssertEqualObjects([[comunicatorMock URLToFetch] absoluteString], url , @"The URL fetching to get result operation");
}

- (void) testHaveToCreateANewConnectionWhenFetchNewResult {
    id initialConnection = [OCMockObject niceMockForClass:[NSURLConnection class]];
    CalculatorComunicatorMock *comunicatorWithNSConectionMock = [[CalculatorComunicatorMock alloc] initWithURLConnection: initialConnection];
    
    [comunicatorWithNSConectionMock fetchingResult:@2 secondOperand:@2 operator:ADD];
    
    id newConnection = [comunicatorWithNSConectionMock currentURLConnection];
    
    STAssertFalse(initialConnection == newConnection, @"Each new fetch result the connection shoud be new.");
}

- (void) testShouldCancelTheOldConnectionWhenFetchNewResult {
    id connection = [OCMockObject mockForClass:[NSURLConnection class]];
    CalculatorComunicatorMock *comunicatorWithNSConectionMock = [[CalculatorComunicatorMock alloc] initWithURLConnection: connection];
    
    [[connection expect] cancel];
    
    [comunicatorWithNSConectionMock fetchingResult:@2 secondOperand:@1 operator:ADD];
    
    [connection verify];
}


- (void)testReceivingResponseDiscardsExistingData {
    id response = [self HTTPURLWithStatusCode: @200];
    
    comunicatorMock.receivedData = [NSMutableData dataWithData:[@"Hello" dataUsingEncoding: NSUTF8StringEncoding]];

    [comunicatorMock connection:[comunicatorMock currentURLConnection] didReceiveResponse:response];
    
    STAssertEquals([comunicatorMock.receivedData length], (NSUInteger)0, @"Data should have been discarded");
}
- (void)testReceivingResponseWith404StatusPassesErrorToDelegate {
    id fourOhFourResponse = [self HTTPURLWithStatusCode:@404];
        
    [[delegate expect] resultOperationFailedWithError: [OCMArg checkWithBlock:^BOOL(id value) {
        if (value && [value isKindOfClass:[NSError class]]
            && [value code] == 404
            && [[value domain] isEqualToString:AmazonCommunicatorErrorDomain]) {
            return YES;
        }
        
        return NO;
    }]];
     
    [comunicatorMock connection:nil didReceiveResponse:fourOhFourResponse];
    
    [delegate verify];
}

- (id)HTTPURLWithStatusCode:(NSValue *) statusCode {
    id response = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    
    [[[response stub] andReturnValue:statusCode] statusCode];
    return response;
}

- (void)testNoErrorReceivedOn200Status {
    id twoHundredResponse = [self HTTPURLWithStatusCode:@200];
    
    [comunicatorMock connection: nil didReceiveResponse: twoHundredResponse];
    
    STAssertNoThrow([delegate verify], @"No need for error on 200 response");
}
- (void)testConnectionFailingPassesErrorToDelegate {
    NSError *error = [NSError errorWithDomain: @"Fake domain" code: 12345 userInfo: nil];
    
    [[delegate expect] resultOperationFailedWithError:error];
    
    [comunicatorMock connection: nil didFailWithError: error];
    
    [delegate verify];
}
- (void)testSuccessfulOperationPassesDataToDelegate {

    [[delegate expect] resultOperation:@"Result"];
    
    [comunicatorMock setReceivedData: [NSMutableData dataWithData:[@"Result" dataUsingEncoding: NSUTF8StringEncoding]]];
    [comunicatorMock connectionDidFinishLoading: nil];
    
    [delegate verify];
}

- (void)testAdditionalDataAppendedToDownload {
    [comunicatorMock setReceivedData: [NSMutableData dataWithData:[@"Result" dataUsingEncoding: NSUTF8StringEncoding]]];
    
    NSData *extraData = [@" appended" dataUsingEncoding: NSUTF8StringEncoding];
    
    [comunicatorMock connection: nil didReceiveData: extraData];
    
    NSString *combinedString = [[NSString alloc] initWithData: [comunicatorMock receivedData] encoding: NSUTF8StringEncoding];
    
    STAssertEqualObjects(combinedString, @"Result appended", @"Received data should be appended to the downloaded data");
}

@end
