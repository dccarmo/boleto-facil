//
//  BFOUtilidadesBoleto.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOUtilidadesBoleto.h"

#define ANO_BASE 1997
#define MES_BASE 10
#define DIA_BASE 07

@implementation BFOUtilidadesBoleto

- (NSString *)bancoDoCodigoBarra:(NSString *)codigoBarra
{
    NSArray *listaBancos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOListaBancos" ofType:@"plist"]];
    NSString *codigoBanco = [codigoBarra substringWithRange:NSRangeFromString(@"0-3")];
    NSString *nomeBanco = nil;
    NSDictionary *banco;
    
    for (banco in listaBancos) {
        if ([banco[@"codigo"] isEqualToString:codigoBanco]) {
            nomeBanco = banco[@"nome"];
            
            break;
        }
    }
    
    return nomeBanco;
}

- (NSDate *)dataVencimentoDoCodigoBarra:(NSString *)codigoBarra
{
    NSString *fatorVencimento = [codigoBarra substringWithRange:NSRangeFromString(@"5-4")];
    NSDateComponents *componentesDataInicio = [NSDateComponents new];
    NSDateComponents *componentesDataSoma = [NSDateComponents new];
    
    [componentesDataInicio setYear:ANO_BASE];
    [componentesDataInicio setMonth:MES_BASE];
    [componentesDataInicio setDay:DIA_BASE];
    
    [componentesDataSoma setDay:[fatorVencimento integerValue]];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:componentesDataSoma
                                                         toDate:[[NSCalendar currentCalendar] dateFromComponents:componentesDataInicio]
                                                        options:0];
}

- (NSString *)digitoVerificadorLinhaDigitavelDaSequencia:(NSString *)sequencia
{
    NSUInteger soma, peso, multiplicacao, digito;
    
    soma = 0;
    peso = 2;
    
    for (NSInteger i = [sequencia length] - 1; i >= 0; i--) {
        multiplicacao = [[sequencia substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-1", i])] integerValue] * peso;
        
        if (multiplicacao >= 10) {
            multiplicacao = 1 + multiplicacao - 10;
        }
        
        soma = soma + multiplicacao;
        
        if (peso == 1) {
            peso = 2;
        } else {
            peso = 1;
        }
    }
    
    digito = 10 - (soma % 10);
    
    if (digito == 10) {
        digito = 0;
    }
    
    return [NSString stringWithFormat:@"%d",digito];
}

- (NSString *)digitoVerificadorCodigoBarraDaSequencia:(NSString *)sequencia
{
    NSUInteger soma, peso, base, resto, digito;
    
    soma = 0;
    peso = 2;
    base = 9;
    resto = 0;
    
    for (NSInteger i = [sequencia length] - 1; i >= 0; i--) {
        soma = soma + [[sequencia substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-%d", i, i + 1])] integerValue] * peso;
        
        if (peso < base) {
            peso++;
        } else {
            peso = 2;
        }
    }
    
    digito = 11 - (soma % 11);
    
    if (digito > 9) {
        digito = 0;
    }
    
    if (digito == 0) {
        digito = 1;
    }
    
    return [NSString stringWithFormat:@"%d",digito];
}

@end