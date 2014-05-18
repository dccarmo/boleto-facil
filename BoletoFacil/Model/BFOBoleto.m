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
    NSDate *_dataVencimento;
    NSString *_valorExtenso;
    NSMutableArray *_lembretes;
}

@property (nonatomic) NSString *codigoBanco;
@property (nonatomic) NSString *codigoCategoria;

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
        _codigoBanco = [coder decodeObjectForKey:@"codigoBanco"];
        _codigoCategoria = [coder decodeObjectForKey:@"codigoCategoria"];
        _dataVencimento = [coder decodeObjectForKey:@"dataVencimento"];
        _valorExtenso = [coder decodeObjectForKey:@"valorExtenso"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.codigoBarras forKey:@"codigoBarras"];
    [coder encodeObject:self.data forKey:@"data"];
    [coder encodeObject:self.codigoBanco forKey:@"codigoBanco"];
    [coder encodeObject:self.codigoCategoria forKey:@"codigoCategoria"];
    [coder encodeObject:self.dataVencimento forKey:@"dataVencimento"];
    [coder encodeObject:self.valorExtenso forKey:@"valorExtenso"];
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

- (NSString *)codigoBanco
{
    if (!_codigoBanco) {
        _codigoBanco = [self.codigoBarras substringWithRange:NSRangeFromString(@"0-3")];
        
        if (self.tipo == BFOTipoBoletoArrecadacao) {
            _codigoBanco = @"0";
        }
    }
    
    return _codigoBanco;
}

- (NSString *)banco
{
    NSArray *listaBancos;
    
    listaBancos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOListaBancos" ofType:@"plist"]];
    
    for (NSDictionary *banco in listaBancos) {
        if ([banco[@"codigo"] isEqualToString:self.codigoBanco]) {
            return banco[@"nome"];
        }
    }
    
    return @"-";
}

- (NSString *)codigoCategoria
{
    if (!_codigoCategoria) {
        _codigoCategoria = [self.codigoBarras substringWithRange:NSRangeFromString(@"1-1")];
        
        if (self.tipo == BFOTipoBoletoBancario) {
            _codigoCategoria = @"0";
        }
    }
    
    return _codigoCategoria;
}

- (NSString *)categoria
{
    NSArray *listaCategorias;
    
    listaCategorias = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOListaCategorias" ofType:@"plist"]];
    
    for (NSDictionary *categoria in listaCategorias) {
        if ([categoria[@"codigo"] isEqualToString:self.codigoCategoria]) {
            return categoria[@"nome"];
        }
    }
    
    return @"Outros";
}

- (UIColor *)corCategoria
{
    UIColor *cor;
    
    switch ([self.codigoCategoria integerValue]) {
        case 1:
            cor = [UIColor colorWithRed:1 green:0.647 blue:0.007 alpha:1];
            break;
            
        case 2:
            cor = [UIColor colorWithRed:0 green:0.568 blue:1 alpha:1];
            break;
            
        case 3:
            cor = [UIColor colorWithRed:1 green:0.823 blue:0.007 alpha:1];
            break;
            
        case 4:
            cor = [UIColor colorWithRed:0.415 green:0.443 blue:0.894 alpha:1];
            break;
            
        case 5:
            cor = [UIColor colorWithRed:1 green:0.647 blue:0.007 alpha:1];
            break;
            
        case 7:
            cor = [UIColor colorWithRed:0.38 green:0.823 blue:0.996 alpha:1];
            break;
            
        default:
            cor = [UIColor colorWithRed:0.282 green:0.858 blue:0.419 alpha:1];
            break;
    }
    
    return cor;
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
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"9-8")] intValue],
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"17-2")] intValue]] floatValue];
                break;
                
            case BFOTipoBoletoArrecadacao:
                valor = [[NSString stringWithFormat:@"%d.%d",
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"4-9")] intValue],
                          [[self.codigoBarras substringWithRange:NSRangeFromString(@"13-2")] intValue]] floatValue];
                break;
        }
        
        _valorExtenso = [formatoNumero stringFromNumber:[NSNumber numberWithFloat:valor]];
    }
    
    return _valorExtenso;
}

- (NSArray *)lembretes
{
    if (!_lembretes) {
        _lembretes = [NSMutableArray new];
    }
    
    return _lembretes;
}

- (void)agendarLembrete:(NSString *)titulo data:(NSDate *)dataLembrete
{
    UILocalNotification *notificacao;
    
    notificacao = [UILocalNotification new];
    notificacao.fireDate = dataLembrete;
    notificacao.alertBody = titulo;
    notificacao.userInfo = @{@"codigoBarras":self.codigoBarras};
    notificacao.soundName = UILocalNotificationDefaultSoundName;
    notificacao.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notificacao];
    
    [_lembretes addObject:notificacao];
}

- (void)cancelarLembrete:(UILocalNotification *)notificacao
{
    [[UIApplication sharedApplication] cancelLocalNotification:notificacao];
    
    [_lembretes removeObject:notificacao];
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

@end
