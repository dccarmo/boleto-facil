//
//  BFOCodigoBarra.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFOGerenciadorCodigoBarra : NSObject

@property (nonatomic, weak, readonly) NSMutableDictionary *ultimoCodigo;

+ (id)sharedGerenciadorCodigoBarra;

- (NSDictionary *)codigoNoIndice:(NSInteger)indice;
- (void)adicionarCodigo:(NSString *)codigo;
- (NSInteger)quantidadeCodigosArmazenados;
- (NSDictionary *)ultimoCodigo;

@end
