//
//  BFOBoleto.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BFOTipoBoleto)
{
    BFOTipoBoletoBancario,
    BFOTipoBoletoArrecadacao
};

@interface BFOBoleto : NSObject <NSCoding, UIActivityItemSource>

@property (nonatomic, readonly) NSString *codigoBarras;
@property (nonatomic, readonly) NSDate *data;

@property (nonatomic ,readonly) BFOTipoBoleto tipo;
@property (nonatomic, readonly) NSString *linhaDigitavel;
@property (nonatomic, readonly) NSString *banco;
@property (nonatomic, readonly) NSString *segmento;
@property (nonatomic, readonly) NSDate *dataVencimento;
@property (nonatomic, readonly) NSString *valorExtenso;

@property (nonatomic) NSString *tituloLembrete;
@property (nonatomic) NSDate *dataLembrete;

- (instancetype)initWithCodigoBarras:(NSString *)codigoBarras;
- (NSArray *)sequenciasLinhaDigitavel;
- (NSString *)linhaDigitavelFormatada;

@end
