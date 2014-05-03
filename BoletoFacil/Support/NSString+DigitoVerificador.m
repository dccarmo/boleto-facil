//
//  NSString+DigitoVerificador.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "NSString+DigitoVerificador.h"

@implementation NSString (DigitoVerificador)

- (NSString *)digitoVerificadorLinhaDigitavel
{
    NSUInteger soma, peso, multiplicacao, digito;
    
    soma = 0;
    peso = 2;
    
    for (NSInteger i = [self length] - 1; i >= 0; i--) {
        multiplicacao = [[self substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-1", i])] integerValue] * peso;
        
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

- (NSString *)digitoVerificadorCodigoBarra
{
    NSUInteger soma, peso, base, resto, digito;
    
    soma = 0;
    peso = 2;
    base = 9;
    resto = 0;
    
    for (NSInteger i = [self length] - 1; i >= 0; i--) {
        soma = soma + [[self substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-%d", i, i + 1])] integerValue] * peso;
        
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
