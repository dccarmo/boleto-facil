//
//  DCCBoletoBancarioFormatter.m
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "DCCBoletoBancarioFormatter.h"

//Support
#import "NSString+DigitoVerificador.h"

#define TAM_CODIGO_BOLETO 43

@implementation DCCBoletoBancarioFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *codigo, *campo1, *campo2, *campo3, *campo4, *campo5;
    
    if (![obj isKindOfClass:[NSString class]]){
       return nil;
    }
    
    if ([obj length] < TAM_CODIGO_BOLETO) {
        return nil;
    }
    
    codigo = obj;
    
    campo1 = [NSString stringWithFormat:@"%@%@%@",
              [codigo substringWithRange:NSRangeFromString(@"0-4")],
              [codigo substringWithRange:NSRangeFromString(@"19-1")],
              [codigo substringWithRange:NSRangeFromString(@"20-4")]];
    campo1 = [campo1 stringByAppendingString:[campo1 digitoVerificadorLinhaDigitavel]];
    
    campo2 = [NSString stringWithFormat:@"%@%@",
              [codigo substringWithRange:NSRangeFromString(@"24-5")],
              [codigo substringWithRange:NSRangeFromString(@"29-5")]];
    campo2 = [campo2 stringByAppendingString:[campo2 digitoVerificadorLinhaDigitavel]];
    
    campo3 = [NSString stringWithFormat:@"%@%@",
              [codigo substringWithRange:NSRangeFromString(@"34-5")],
              [codigo substringWithRange:NSRangeFromString(@"39-5")]];
    campo3 = [campo3 stringByAppendingString:[campo3 digitoVerificadorLinhaDigitavel]];
    
    campo4 = [codigo substringWithRange:NSRangeFromString(@"4-1")];
    
    campo5 = [codigo substringWithRange:NSRangeFromString(@"5-14")];
    if ([campo5 isEqualToString:@"0"]) {
        campo5 = @"000";
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@", campo1, campo2, campo3, campo4, campo5];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    return YES;
}

@end
