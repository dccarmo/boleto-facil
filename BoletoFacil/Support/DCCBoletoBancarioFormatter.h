//
//  DCCBoletoBancarioFormatter.h
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCCBoletoBancarioFormatter : NSFormatter

/**
 *  Retorna a linha digitavel
 *
 */
- (NSString *)linhaDigitavelDoCodigoBarra:(NSString *)codigoBarra;
- (NSString *)codigoBarraDaLinhaDigitavel:(NSString *)linhaDigitavel;

@end