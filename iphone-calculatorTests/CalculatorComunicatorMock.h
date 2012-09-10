//
//  CalculatorComunicatorMock.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import "CalculatorComunicatorAmazon.h"

@interface CalculatorComunicatorMock : CalculatorComunicatorAmazon 
- (id) initWithURLConnection:(NSURLConnection *) connection;
- (NSURL *) URLToFetch;
- (NSURLConnection *) currentURLConnection;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@property (nonatomic) NSMutableData * receivedData;
@end
