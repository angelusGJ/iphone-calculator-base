//
//  CalculatorComunicatorAmazon.h
//  iphone-calculator
//
//  Created by Angel Garcia Jerez on 27/08/12.
//  Copyright (c) 2012 Angel Garcia Jerez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorComunicator.h"

@interface CalculatorComunicatorAmazon : NSObject<CalculatorComunicator> {
@protected
    NSURL* fetchingURL;
    NSURLConnection *fetchConnection;
    NSMutableData *receivedData;
}
@end

extern NSString *AmazonCommunicatorErrorDomain;