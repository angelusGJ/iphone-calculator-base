//
//  CalculatorComunicatorAmazon.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorComunicatorAmazon.h"

@implementation CalculatorComunicatorAmazon

@synthesize delegate;

- (void) setDelegate:(id<CalculatorComunicatorDelegate>)newDelegate {
    NSParameterAssert(newDelegate);
    
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(CalculatorComunicatorDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"delegate object does not conform the correct protocol" userInfo:nil] raise];
    }
    
    delegate = newDelegate;
}

- (void) fetchingResult:(NSNumber *) firstOperand secondOperand: (NSNumber *) secondOperand operator: (enum Operator) operator {
    [self fetchResultAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-247-37-1.eu-west-1.compute.amazonaws.com:8080/demo-ws-spring-mvc/rest/calc/%.02f/%.02f/%d", [firstOperand doubleValue], [secondOperand doubleValue], operator]]];
}

- (void)lauchConnectionForRequest:(NSURLRequest *)request {
    fetchConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) fetchResultAtURL:(NSURL *)url {
    fetchingURL = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    [self cancelAndDiscardURLConnection];
    [self lauchConnectionForRequest:request];
}

- (void) cancelAndDiscardURLConnection {
    if (fetchConnection) {
        [fetchConnection cancel];
        fetchConnection = nil;
    }
}

- (void)dealloc {
    [fetchConnection cancel];
}

#pragma Delegate Methods NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError
                          errorWithDomain: AmazonCommunicatorErrorDomain
                          code: [httpResponse statusCode]
                          userInfo: nil];
        
        [delegate resultOperationFailedWithError: error];
        [self cancelAndDiscardURLConnection];
                           
    } else {
        receivedData = [[NSMutableData alloc] init];
    }
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    receivedData = nil;
    fetchConnection = nil;
    fetchingURL = nil;
    [delegate resultOperationFailedWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    fetchConnection = nil;
    fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData: receivedData encoding: NSUTF8StringEncoding];
    receivedData = nil;
    
    [delegate resultOperation:receivedText];
}

@end

NSString *AmazonCommunicatorErrorDomain = @"AmazonCommunicatorErrorDomain";
