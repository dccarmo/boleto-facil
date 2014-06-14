//
//  BFOAppDelegate.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOAppDelegate.h"

//View Controllers
#import "BFONavegacaoPrincipalViewController.h"

//Support
#import "BFOArmazenamentoBoleto.h"

NSString * const BFOOrdenacaoTelaPrincipalKey = @"OrdenacaoTelaPrincipal";
NSString * const BFOMostrarBoletosVencidosKey = @"MostrarBoletosVencidos";
NSString * const BFOMostrarBoletosPagosKey = @"MostrarBoletosPagos";

@implementation BFOAppDelegate

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults registerDefaults:@{BFOOrdenacaoTelaPrincipalKey: @0,
                                 BFOMostrarBoletosVencidosKey: @YES,
                                 BFOMostrarBoletosPagosKey: @YES}];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *notificacao;
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = [BFONavegacaoPrincipalViewController new];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navegacaoPrincipal;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setApplicationStyle];
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        notificacao = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [navegacaoPrincipal mostrarBoleto:[[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notificacao.userInfo[@"codigoBarras"]]];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)setApplicationStyle
{
    UIColor *tintColor = [UIColor colorWithRed:1 green:0.27 blue:0.317 alpha:1];
    UIColor *navigationBarBackgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
    UIColor *preto = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    
    //UIView
    [UIView appearance].tintColor = tintColor;
    
    //UINavigationBar
    [UINavigationBar appearance].backgroundColor = navigationBarBackgroundColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:preto};
    [UINavigationBar appearance].barTintColor = navigationBarBackgroundColor;
}

@end
