//
//  BFOBoleto.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOBoleto.h"

//Support
#import "DCCBoletoBancarioFormatter.h"

static const NSUInteger anoBase = 1997;
static const NSUInteger mesBase = 10;
static const NSUInteger diaBase = 07;

@interface BFOBoleto () {
    NSString *_linhaDigitavel;
    NSString *_banco;
    NSDate *_dataVencimento;
    NSString *_valorExtenso;
}

@end

@implementation BFOBoleto

- (instancetype)initWithCodigoBarras:(NSString *)codigoBarras
{
    self = [super init];
    if (self) {
        _codigoBarras = codigoBarras;
        _data = [NSDate date];
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _codigoBarras = [coder decodeObjectForKey:@"codigoBarras"];
        _data = [coder decodeObjectForKey:@"data"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.codigoBarras forKey:@"codigoBarras"];
    [coder encodeObject:self.data forKey:@"data"];
}

#pragma mark - BFOBoleto

- (NSString *)linhaDigitavel
{
    DCCBoletoBancarioFormatter *formatoBoleto;
    
    if (!_linhaDigitavel) {
        formatoBoleto = [DCCBoletoBancarioFormatter new];
        
        _linhaDigitavel = [formatoBoleto linhaDigitavelDoCodigoBarra:self.codigoBarras];
    }
    
    return _linhaDigitavel;
}

- (NSString *)banco
{
    NSArray *listaBancos;
    NSString *codigoBanco;
    NSDictionary *banco;
    
    if (!_banco) {
        listaBancos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOListaBancos" ofType:@"plist"]];
        codigoBanco = [self.codigoBarras substringWithRange:NSRangeFromString(@"0-3")];
        
        for (banco in listaBancos) {
            if ([banco[@"codigo"] isEqualToString:codigoBanco]) {
                _banco = banco[@"nome"];
                
                break;
            }
        }
    }
    
    return _banco;
}

- (NSDate *)dataVencimento
{
    NSString *fatorVencimento;
    NSDateComponents *componentesDataInicio;
    NSDateComponents *componentesDataSoma;
    
    if (!_dataVencimento) {
        fatorVencimento = [self.codigoBarras substringWithRange:NSRangeFromString(@"5-4")];
        componentesDataInicio = [NSDateComponents new];
        componentesDataSoma = [NSDateComponents new];
        
        [componentesDataInicio setYear:anoBase];
        [componentesDataInicio setMonth:mesBase];
        [componentesDataInicio setDay:diaBase];
        
        [componentesDataSoma setDay:[fatorVencimento integerValue]];
        
        _dataVencimento = [[NSCalendar currentCalendar] dateByAddingComponents:componentesDataSoma
                                                                        toDate:[[NSCalendar currentCalendar] dateFromComponents:componentesDataInicio]
                                                                       options:0];
    }
    
    return _dataVencimento;
}

- (NSString *)valorExtenso
{
    CGFloat valor;
    NSNumberFormatter *formatoNumero;
    
    if (!_valorExtenso) {
        formatoNumero = [NSNumberFormatter new];
        [formatoNumero setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        valor = [[NSString stringWithFormat:@"%d.%d",
                  [[self.codigoBarras substringWithRange:NSRangeFromString(@"9-8")] integerValue],
                  [[self.codigoBarras substringWithRange:NSRangeFromString(@"17-2")] integerValue]] floatValue];
        
        _valorExtenso = [formatoNumero stringFromNumber:[NSNumber numberWithFloat:valor]];
    }
    
    return _valorExtenso;
}

@end
