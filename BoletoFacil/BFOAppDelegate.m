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

//Pods
#import <GAI.h>
#import <RMStore.h>
#import <RMAppReceipt.h>
#import <RMStoreAppReceiptVerificator.h>
#import <iRate.h>

NSString *const BFONumeroBoletosLidosKey = @"NumeroBoletosLidos";
NSString *const BFOAplicativoDesbloqueadoKey = @"AplicativoDesbloqueado";
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
    
    [defaults registerDefaults:@{BFONumeroBoletosLidosKey: @0,
                                 BFOOrdenacaoTelaPrincipalKey: @0,
                                 BFOAplicativoDesbloqueadoKey: @NO,
                                 BFOMostrarBoletosVencidosKey: @YES,
                                 BFOMostrarBoletosPagosKey: @YES,
                                 BFONenhumBoletoLidoKey: @YES,
                                 BFONenhumBoletoVisualizadoKey: @YES}];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setApplicationStyle];
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        BFONavegacaoPrincipalViewController *navegacaoPrincipal = (BFONavegacaoPrincipalViewController *) self.window.rootViewController;
        UILocalNotification *notificacao;
        
        notificacao = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [navegacaoPrincipal mostrarBoleto:[[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notificacao.userInfo[@"codigoBarras"]]];
    }
    
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-9367655-6"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:BFOAplicativoDesbloqueadoKey]) {
        [[RMStore defaultStore] refreshReceiptOnSuccess:^{
            RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
            
            CGFloat originalAppVersion = [receipt.originalAppVersion floatValue];
            
            if (originalAppVersion < 1.2) {
                [defaults setObject:@(YES) forKey:BFOAplicativoDesbloqueadoKey];
                [defaults synchronize];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    [iRate sharedInstance].eventsUntilPrompt = 5;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationSettings *userNotificationSettings = application.currentUserNotificationSettings;
        
        if ((userNotificationSettings.types & UIUserNotificationTypeBadge) != 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
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
}

@end
