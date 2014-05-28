//
//  NSCalendar+Calculations.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "NSCalendar+Calculations.h"

@implementation NSCalendar (Calculations)

- (NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
    NSInteger startDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                       inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                     inUnit: NSEraCalendarUnit forDate:endDate];
    return endDay-startDay;
}

@end
