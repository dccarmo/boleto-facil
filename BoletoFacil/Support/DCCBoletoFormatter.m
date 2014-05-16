//
//  DCCBoletoFormatter.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 16/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "DCCBoletoFormatter.h"

static const NSUInteger tamanhoMaximoCodigoBarras = 44;

@implementation DCCBoletoFormatter

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    NSString *codigo;
    
    if (![obj isKindOfClass:[NSString class]]){
        return nil;
    }
    
    if ([obj length] < tamanhoMaximoCodigoBarras) {
        return nil;
    }
    
    codigo = obj;
    
    switch ([codigo characterAtIndex:0]) {
        case '8':
            return [self criarSequenciaBoletoArrecadacao:codigo];
            
        default:
            return [self criarSequenciaBoletoBancario:codigo];
    }
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    return YES;
}

#pragma mark - DCCBoletoFormatter

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

- (NSString *)criarSequenciaBoletoArrecadacao:(NSString *)codigo
{
    NSString *sequencia1, *sequencia2, *sequencia3, *sequencia4;
    
    sequencia1 = [codigo substringWithRange:NSRangeFromString(@"0-11")];
    sequencia1 = [sequencia1 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia1]];
    
    sequencia2 = [codigo substringWithRange:NSRangeFromString(@"11-11")];
    sequencia2 = [sequencia2 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia2]];
    
    sequencia3 = [codigo substringWithRange:NSRangeFromString(@"22-11")];
    sequencia3 = [sequencia3 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia3]];
    
    sequencia4 = [codigo substringWithRange:NSRangeFromString(@"33-11")];
    sequencia4 = [sequencia4 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia4]];
    
    return [NSString stringWithFormat:@"%@%@%@%@", sequencia1, sequencia2, sequencia3, sequencia4];
}

- (NSString *)criarSequenciaBoletoBancario:(NSString *)codigo
{
    NSString *sequencia1, *sequencia2, *sequencia3, *sequencia4, *sequencia5;
    
    sequencia1 = [NSString stringWithFormat:@"%@%@%@",
                  [codigo substringWithRange:NSRangeFromString(@"0-4")],
                  [codigo substringWithRange:NSRangeFromString(@"19-1")],
                  [codigo substringWithRange:NSRangeFromString(@"20-4")]];
    sequencia1 = [sequencia1 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia1]];
    
    sequencia2 = [NSString stringWithFormat:@"%@%@",
                  [codigo substringWithRange:NSRangeFromString(@"24-5")],
                  [codigo substringWithRange:NSRangeFromString(@"29-5")]];
    sequencia2 = [sequencia2 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia2]];
    
    sequencia3 = [NSString stringWithFormat:@"%@%@",
                  [codigo substringWithRange:NSRangeFromString(@"34-5")],
                  [codigo substringWithRange:NSRangeFromString(@"39-5")]];
    sequencia3 = [sequencia3 stringByAppendingString:[self digitoVerificadorModulo10DaSequencia:sequencia3]];
    
    sequencia4 = [codigo substringWithRange:NSRangeFromString(@"4-1")];
    
    sequencia5 = [codigo substringWithRange:NSRangeFromString(@"5-14")];
    
    return [NSString stringWithFormat:@"%@%@%@%@%@", sequencia1, sequencia2, sequencia3, sequencia4, sequencia5];
}

- (NSString *)digitoVerificadorModulo10DaSequencia:(NSString *)sequencia
{
    NSUInteger soma, peso, multiplicacao, digito;
    
    soma = 0;
    peso = 2;
    
    for (NSInteger i = [sequencia length] - 1; i >= 0; i--) {
        multiplicacao = [[sequencia substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-1", (int) i])] integerValue] * peso;
        
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
    
    return [NSString stringWithFormat:@"%d", (int) digito];
}

- (NSString *)digitoVerificadorModulo11DaSequencia:(NSString *)sequencia
{
    NSUInteger soma, peso, base, resto, digito;
    
    soma = 0;
    peso = 2;
    base = 9;
    resto = 0;
    
    for (NSInteger i = [sequencia length] - 1; i >= 0; i--) {
        soma = soma + [[sequencia substringWithRange:NSRangeFromString([NSString stringWithFormat:@"%d-%d", (int) i, (int) i + 1])] integerValue] * peso;
        
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
    
    return [NSString stringWithFormat:@"%d", (int) digito];
}

@end
