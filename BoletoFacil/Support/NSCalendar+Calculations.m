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
    NSInteger startDay=[self ordinalityOfUnit:NSCalendarUnitDay
                                       inUnit: NSCalendarUnitEra forDate:startDate];
    NSInteger endDay=[self ordinalityOfUnit:NSCalendarUnitDay
                                     inUnit: NSCalendarUnitEra forDate:endDate];
    return endDay-startDay;
}

@end
