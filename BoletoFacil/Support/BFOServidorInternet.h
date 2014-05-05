//
//  BFOServidorWeb.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 04/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <Foundation/Foundation.h>

//Pods
#import <GCDWebServer.h>

@interface BFOServidorInternet : NSObject

+ (id)sharedServidorInternet;

- (void)iniciarServidor;
- (NSString *)URLServidor;
- (BOOL)mostrarBoleto:(NSDictionary *)boleto mensagemErro:(NSString **)mensagemErro;

@end
