//
//  BFOMostrarBoletoView.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 28/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BFOEstadoCriacaoServidor)
{
    BFOEstadoCriacaoServidorIniciando,
    BFOEstadoCriacaoServidorSucesso,
    BFOEstadoCriacaoServidorAviso,
    BFOEstadoCriacaoServidorFalha
};

@interface BFOMostrarBoletoView : UIView

- (void)alterarEstadoCriacaoServidor:(BFOEstadoCriacaoServidor)estado mensagem:(NSString *)mensagem;
- (void)configurarViewComBoleto:(NSDictionary *)boleto;

@end
