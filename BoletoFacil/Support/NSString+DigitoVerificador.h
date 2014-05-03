//
//  NSString+DigitoVerificador.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 03/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DigitoVerificador)

- (NSString *)digitoVerificadorLinhaDigitavel;
- (NSString *)digitoVerificadorCodigoBarra;

@end
