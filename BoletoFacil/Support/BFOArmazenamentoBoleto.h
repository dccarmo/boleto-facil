//
//  BFOCodigoBarra.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFOArmazenamentoBoleto : NSObject

@property (nonatomic, readonly) NSMutableArray *boletos;

+ (instancetype)sharedArmazenamentoBoleto;

- (void)salvar;

@end
