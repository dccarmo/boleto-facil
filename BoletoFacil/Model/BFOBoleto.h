//
//  BFOBoleto.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFOBoleto : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *codigoBarras;
@property (nonatomic, readonly) NSDate *data;

@property (nonatomic, readonly) NSString *linhaDigitavel;
@property (nonatomic, readonly) NSString *banco;
@property (nonatomic, readonly) NSDate *dataVencimento;
@property (nonatomic, readonly) NSString *valorExtenso;

- (instancetype)initWithCodigoBarras:(NSString *)codigoBarras;
- (NSArray *)sequenciasLinhaDigitavel;
- (NSString *)linhaDigitavelFormatada;

@end
