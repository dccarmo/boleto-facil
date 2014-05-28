//
//  NSCalendar+Calculations.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Calculations)

- (NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;

@end
