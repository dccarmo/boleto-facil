//
//  DCCBoletoFormatter.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 16/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCCBoletoFormatter : NSFormatter

- (NSString *)linhaDigitavelDoCodigoBarra:(NSString *)codigoBarra;
- (NSString *)codigoBarraDaLinhaDigitavel:(NSString *)linhaDigitavel;

@end
