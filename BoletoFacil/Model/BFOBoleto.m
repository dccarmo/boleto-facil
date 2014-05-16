//
//  BFOBoleto.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOBoleto.h"

//Support
#import "DCCBoletoFormatter.h"

static const NSUInteger anoBase = 1997;
static const NSUInteger mesBase = 10;
static const NSUInteger diaBase = 07;

@interface BFOBoleto () {
    NSString *_linhaDigitavel;
    NSString *_banco;
    NSString *_segmento;
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
        _banco = [coder decodeObjectForKey:@"banco"];
        _segmento = [coder decodeObjectForKey:@"segmento"];
        _dataVencimento = [coder decodeObjectForKey:@"dataVencimento"];
        _valorExtenso = [coder decodeObjectForKey:@"valorExtenso"];
        _tituloLembrete = [coder decodeObjectForKey:@"tituloLembrete"];
        _dataLembrete = [coder decodeObjectForKey:@"dataLembrete"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.codigoBarras forKey:@"codigoBarras"];
    [coder encodeObject:self.data forKey:@"data"];
    [coder encodeObject:self.banco forKey:@"banco"];
    [coder encodeObject:self.segmento forKey:@"segmento"];
    [coder encodeObject:self.dataVencimento forKey:@"dataVencimento"];
    [coder encodeObject:self.valorExtenso forKey:@"valorExtenso"];
    [coder encodeObject:self.tituloLembrete forKey:@"tituloLembrete"];
    [coder encodeObject:self.dataLembrete forKey:@"dataLembrete"];
}

#pragma mark - BFOBoleto

- (BFOTipoBoleto)tipo
{
    switch ([self.codigoBarras characterAtIndex:0]) {
        case '8':
            return BFOTipoBoletoArrecadacao;
            
        default:
            return BFOTipoBoletoBancario;
    }
}

- (NSString *)linhaDigitavel
{
    DCCBoletoFormatter *formatoBoleto;
    
    if (!_linhaDigitavel) {
        formatoBoleto = [DCCBoletoFormatter new];
        
        _linhaDigitavel = [formatoBoleto linhaDigitavelDoCodigoBarra:self.codigoBarras];
    }
    
    return _linhaDigitavel;
}

- (NSArray *)sequenciasLinhaDigitavel
{
    switch (self.tipo) {
        case BFOTipoBoletoBancario:
            return @[[self.linhaDigitavel substringWithRange:NSRangeFromString(@"0-5")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"5-5")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"10-5")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"15-6")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"21-5")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"26-6")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"32-1")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"33-14")]];
            
        case BFOTipoBoletoArrecadacao:
            return @[[self.linhaDigitavel substringWithRange:NSRangeFromString(@"0-11")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"11-1")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"12-11")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"23-1")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"24-11")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"35-1")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"36-11")],
                     [self.linhaDigitavel substringWithRange:NSRangeFromString(@"47-1")]];
    }
}

- (NSString *)linhaDigitavelFormatada
{
    NSArray *sequencias = [self sequenciasLinhaDigitavel];
    
    switch (self.tipo) {
        case BFOTipoBoletoBancario:
            return [NSString stringWithFormat:@"%@.%@ %@.%@ %@.%@ %@ %@", sequencias[0], sequencias[1], sequencias[2], sequencias[3], sequencias[4], sequencias[5], sequencias[6], sequencias[7]];
            
        case BFOTipoBoletoArrecadacao:
            return [NSString stringWithFormat:@"%@-%@ %@-%@ %@-%@ %@-%@", sequencias[0], sequencias[1], sequencias[2], sequencias[3], sequencias[4], sequencias[5], sequencias[6], sequencias[7]];
    }
}

- (NSString *)banco
{
    NSArray *listaBancos;
    NSString *codigoBanco;
    NSDictionary *banco;
    
    if (!_banco) {
        _banco = @"";
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

- (NSString *)segmento
{
    NSArray *listaSegmentos;
    NSString *codigoSegmento;
    NSDictionary *segmento;
    
    if (!_segmento) {
        _segmento = @"";
        listaSegmentos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOListaSegmentos" ofType:@"plist"]];
        codigoSegmento = [self.codigoBarras substringWithRange:NSRangeFromString(@"1-1")];
        
        for (segmento in listaSegmentos) {
            if ([segmento[@"codigo"] isEqualToString:codigoSegmento]) {
                _segmento = segmento[@"nome"];
                
                break;
            }
        }
    }
    
    return _segmento;
}

- (NSDate *)dataVencimento
{
    NSString *fatorVencimento;
    NSDateComponents *componentesDataInicio;
    NSDateComponents *componentesDataSoma;
    
    if (!_dataVencimento) {
        if (self.tipo == BFOTipoBoletoArrecadacao) {
            return nil;
        }
        
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
        
        switch (self.tipo) {
            case BFOTipoBoletoBancario:
                valor = [[NSString stringWithFormat:@"%d.%d",
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"9-8")] integerValue],
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"17-2")] integerValue]] floatValue];
                
            case BFOTipoBoletoArrecadacao:
                valor = [[NSString stringWithFormat:@"%d.%d",
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"4-9")] integerValue],
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"13-2")] integerValue]] floatValue];
        }
        
        _valorExtenso = [formatoNumero stringFromNumber:[NSNumber numberWithFloat:valor]];
    }
    
    return _valorExtenso;
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [self linhaDigitavelFormatada];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return [self linhaDigitavelFormatada];
}

//- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
//{
//    return [UIImage imageWithImage:[UIImage imageNamed:kCustomURLImageName] scaledToFitToSize:size];
//}

@end
