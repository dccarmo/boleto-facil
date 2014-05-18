//
//  BFOAppDelegate.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const BFOOrdenacaoTelaPrincipalKey;
extern NSString * const BFOMostrarBoletosVencidosKey;
extern NSString * const BFOMostrarBoletosPagosKey;

@interface BFOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
