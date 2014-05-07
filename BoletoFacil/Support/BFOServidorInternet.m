//
//  BFOServidorWeb.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 04/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOServidorInternet.h"

//Models
#import "BFOBoleto.h"

//Support
#import "Reachability.h"

//Pods
#import <GCDWebServerDataResponse.h>

static NSString * const erroSemConexaoWifi = @"Você não está conectado à wi-fi";

@interface BFOServidorInternet () <GCDWebServerDelegate>

@property (nonatomic) GCDWebServer *servidor;
@property (nonatomic) NSString *mensagemErro;
@property (nonatomic) Reachability *reachability;

@end

@implementation BFOServidorInternet

+ (id)sharedServidorInternet
{
    static dispatch_once_t pred;
    static BFOServidorInternet *servidorInternet = nil;
    
    dispatch_once(&pred, ^{
        servidorInternet = [self new];
        [servidorInternet inicializarServidor];
    });
    
    return servidorInternet;
}

- (void)dealloc
{
    if (self.servidor && [self.servidor isRunning]) {
        [self.servidor stop];
    }

    if (self.reachability) {
        [self.reachability stopNotifier];
    }
}

- (Reachability *)reachability
{
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityMudou) name:kReachabilityChangedNotification object:nil];
    }
    
    return _reachability;
}

- (void)inicializarServidor
{
    self.servidor = [GCDWebServer new];
    self.servidor.delegate = self;
    
    [self iniciarServidor];
}

- (void)iniciarServidor
{
    if ([self.servidor isRunning]) {
        [self.servidor stop];
    }
    
    if (self.reachability.currentReachabilityStatus == ReachableViaWiFi) {
        [self.servidor start];
    } else {
        self.mensagemErro = erroSemConexaoWifi;
    }
}

- (NSString *)URLServidor
{
    return [self.servidor.serverURL absoluteString];
}

- (BOOL)mostrarBoleto:(BFOBoleto *)boleto mensagemErro:(NSString **)mensagemErro
{
    NSString *codigo = boleto.codigoBarras;
    
    if (![self.servidor isRunning]) {
        *mensagemErro = self.mensagemErro ? self.mensagemErro : @"Erro desconhecido";
        return NO;
    }
    
    [self.servidor removeAllHandlers];
    
    [self.servidor addDefaultHandlerForMethod:@"GET"
                                 requestClass:[GCDWebServerRequest class]
                                 processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                     
                                     return [GCDWebServerDataResponse responseWithHTML:[NSString stringWithFormat:@"<html><body><p>Seu código de barras é: %@</p></body></html>", codigo]];
                                 }];
    
    return YES;
}

#pragma mark - NSNotificationCenter

- (void)reachabilityMudou
{
    [self iniciarServidor];
}

#pragma mark - GCDWebServerDelegate

- (void)webServerDidStart:(GCDWebServer *)server
{
    
}

- (void)webServerDidStop:(GCDWebServer *)server
{
    
}

@end
