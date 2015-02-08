//
//  BFOAppDelegate.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const BFONumeroBoletosLidosKey;
extern NSString *const BFOAplicativoDesbloqueadoKey;
extern NSString *const BFOOrdenacaoTelaPrincipalKey;
extern NSString *const BFOMostrarBoletosVencidosKey;
extern NSString *const BFOMostrarBoletosPagosKey;
extern NSString *const BFONenhumBoletoLidoKey;
extern NSString *const BFONenhumBoletoVisualizadoKey;

extern NSString *const BFOConfiguracoesDeNotificacoesAlteradaNotification;

extern NSString *const BFOPagoActionIdentifier;
extern NSString *const BFOPagoCategoryIdentifier;

@interface BFOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
