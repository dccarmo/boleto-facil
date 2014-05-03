//
//  BFOUtilidadesBoleto.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TAM_CODIGO_BOLETO 43

@interface BFOUtilidadesBoleto : NSObject

/**
 *  Retorna o nome do banco do codigo de barra informado
 *
 */
- (NSString *)bancoDoCodigoBarra:(NSString *)codigoBarra;

- (NSString *)digitoVerificadorLinhaDigitavelDaSequencia:(NSString *)sequencia;
- (NSString *)digitoVerificadorCodigoBarraDaSequencia:(NSString *)sequencia;
- (NSDate *)dataVencimentoDoCodigoBarra:(NSString *)codigoBarra;

@end
