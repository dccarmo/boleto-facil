//
//  BFOCodigoBarra.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFOBoleto;

@interface BFOArmazenamentoBoleto : NSObject

@property (nonatomic, readonly) NSArray *boletos;

+ (instancetype)sharedArmazenamentoBoleto;

- (BFOBoleto *)adicionarBoletoComCodigoBarras:(NSString *)codigoBarras;
- (void)removerBoleto:(BFOBoleto *)boleto;
- (BFOBoleto *)boletoComCodigoBarras:(NSString *)codigoBarras;
- (void)salvar;

@end
