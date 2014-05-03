//
//  DCCBoletoBancarioFormatter.m
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "DCCBoletoBancarioFormatter.h"

//Support
#import "BFOUtilidadesBoleto.h"

@implementation DCCBoletoBancarioFormatter

#pragma mark - DCCBoletoBancarioFormatter

- (NSString *)linhaDigitavelDoCodigoBarra:(NSString *)codigoBarra
{
    return [self stringForObjectValue:codigoBarra];
}

- (NSString *)codigoBarraDaLinhaDigitavel:(NSString *)linhaDigitavel
{
//    NSString *codigoBarra;
//    
//    [self getObjectValue:codigoBarra forString:linhaDigitavel errorDescription:nil];
    
    return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *codigo, *sequencia1, *sequencia2, *sequencia3, *sequencia4, *sequencia5;
    BFOUtilidadesBoleto *utilidadesBoleto = [BFOUtilidadesBoleto new];
    
    if (![obj isKindOfClass:[NSString class]]){
       return nil;
    }
    
    if ([obj length] < TAM_CODIGO_BOLETO) {
        return nil;
    }
    
    codigo = obj;
    
    sequencia1 = [NSString stringWithFormat:@"%@%@%@",
              [codigo substringWithRange:NSRangeFromString(@"0-4")],
              [codigo substringWithRange:NSRangeFromString(@"19-1")],
              [codigo substringWithRange:NSRangeFromString(@"20-4")]];
    sequencia1 = [sequencia1 stringByAppendingString:[utilidadesBoleto digitoVerificadorLinhaDigitavelDaSequencia:sequencia1]];
    
    sequencia2 = [NSString stringWithFormat:@"%@%@",
              [codigo substringWithRange:NSRangeFromString(@"24-5")],
              [codigo substringWithRange:NSRangeFromString(@"29-5")]];
    sequencia2 = [sequencia2 stringByAppendingString:[utilidadesBoleto digitoVerificadorLinhaDigitavelDaSequencia:sequencia2]];
    
    sequencia3 = [NSString stringWithFormat:@"%@%@",
              [codigo substringWithRange:NSRangeFromString(@"34-5")],
              [codigo substringWithRange:NSRangeFromString(@"39-5")]];
    sequencia3 = [sequencia3 stringByAppendingString:[utilidadesBoleto digitoVerificadorLinhaDigitavelDaSequencia:sequencia3]];
    
    sequencia4 = [codigo substringWithRange:NSRangeFromString(@"4-1")];
    
    if ([NSString stringWithFormat:@""]) {
        
    }
    
    sequencia5 = [codigo substringWithRange:NSRangeFromString(@"5-14")];
    if ([sequencia5 isEqualToString:@"0"]) {
        sequencia5 = @"000";
    }
    
    return [NSString stringWithFormat:@"%@%@%@%@%@", sequencia1, sequencia2, sequencia3, sequencia4, sequencia5];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    return YES;
}

@end
