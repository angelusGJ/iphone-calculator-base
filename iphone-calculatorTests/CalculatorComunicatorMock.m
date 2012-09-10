//
//  CalculatorComunicatorMock.m
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorComunicatorMock.h"
#import <OCMock/OCMock.h>

@implementation CalculatorComunicatorMock

- (id) initWithURLConnection:(NSURLConnection *)newConnection {
    if (self = [super init]) {
        fetchConnection = newConnection;
    }
    
    return self;
}

- (NSURL*) URLToFetch {
    return fetchingURL;
}

- (NSURLConnection *) currentURLConnection {
    return fetchConnection;
}

- (void) lauchConnectionForRequest:(NSURLRequest *)request {
    fetchConnection = [OCMockObject niceMockForClass:[NSURLConnection class]];
}

- (NSMutableData *)receivedData {
    return receivedData;
}

- (void) setReceivedData:(NSMutableData *) newReceivedData {
    receivedData = newReceivedData;
}

@end
