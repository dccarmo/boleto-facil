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

//Model
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

NSString *const BFOOrdenacaoTelaPrincipalKey = @"OrdenacaoTelaPrincipal";
NSString *const BFOMostrarBoletosVencidosKey = @"MostrarBoletosVencidos";
NSString *const BFOMostrarBoletosPagosKey = @"MostrarBoletosPagos";
NSString *const BFONenhumBoletoLidoKey = @"NenhumBoletoLido";
NSString *const BFONenhumBoletoVisualizadoKey = @"NenhumBoletoVisualizado";

NSString *const BFOConfiguracoesDeNotificacoesAlteradaNotification = @"ConfiguracoesDeNotificacoesAlteradaNotification";

NSString *const BFOPagoActionIdentifier = @"PagoActionIdentifier";
NSString *const BFOPagoCategoryIdentifier = @"PagoCategoryIdentifier";

@implementation BFOAppDelegate

#pragma mark - UIApplicationDelegate

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults registerDefaults:@{BFOOrdenacaoTelaPrincipalKey: @0,
                                 BFOMostrarBoletosVencidosKey: @YES,
                                 BFOMostrarBoletosPagosKey: @YES,
                                 BFONenhumBoletoLidoKey: @YES,
                                 BFONenhumBoletoVisualizadoKey: @YES}];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = [BFONavegacaoPrincipalViewController new];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navegacaoPrincipal;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setApplicationStyle];
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        UILocalNotification *notificacao;
        
        notificacao = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [navegacaoPrincipal mostrarBoleto:[[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notificacao.userInfo[@"codigoBarras"]]];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = (BFONavegacaoPrincipalViewController *) self.window.rootViewController;
    
    [navegacaoPrincipal mostrarBoleto:[[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notification.userInfo[@"codigoBarras"]]];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BFOConfiguracoesDeNotificacoesAlteradaNotification object:notificationSettings];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:BFOPagoActionIdentifier]) {
        BFOBoleto *boleto = [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notification.userInfo[@"codigoBarras"]];
        
        if (![boleto.pago boolValue]) {
            [boleto alternaPago];
        }
        
        [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    }
    
    completionHandler();
}


#pragma mark - BFOAppDelegate

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
    
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        [UIActionSheet appearance].tintColor = [UIColor blackColor];
    }
}

@end
