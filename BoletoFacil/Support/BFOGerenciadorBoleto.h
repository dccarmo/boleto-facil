//
//  BFOCodigoBarra.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFOGerenciadorBoleto : NSObject

@property (nonatomic, weak, readonly) NSMutableDictionary *ultimoBoleto;

+ (id)sharedGerenciadorBoleto;

- (NSDictionary *)boletoNoIndice:(NSInteger)indice;
- (void)adicionarCodigoBarras:(NSString *)codigoBarras;
- (NSInteger)quantidadeCodigosArmazenados;

@end
