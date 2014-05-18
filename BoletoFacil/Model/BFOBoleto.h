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
@property (nonatomic, readonly) NSString *categoria;
@property (nonatomic, readonly) UIColor *corCategoria;
@property (nonatomic, readonly) NSDate *dataVencimento;
@property (nonatomic, readonly) NSString *valorExtenso;
@property (nonatomic, readonly) NSArray *lembretes;

- (instancetype)initWithCodigoBarras:(NSString *)codigoBarras;
- (NSArray *)sequenciasLinhaDigitavel;
- (NSString *)linhaDigitavelFormatada;
- (void)agendarLembrete:(NSString *)titulo data:(NSDate *)dataLembrete;
- (void)cancelarLembrete:(UILocalNotification *)notificacao;

@end
