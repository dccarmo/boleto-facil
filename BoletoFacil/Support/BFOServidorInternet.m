//
//  BFOServidorWeb.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 04/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOServidorInternet.h"

//Pods
#import <GCDWebServerDataResponse.h>

@interface BFOServidorInternet () <GCDWebServerDelegate>

@property (nonatomic) GCDWebServer *servidor;
@property (nonatomic) NSString *mensagemErro;

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
}

- (void)inicializarServidor
{
    self.servidor = [GCDWebServer new];
    self.servidor.delegate = self;
    
    [self iniciarServidor];
}

- (void)iniciarServidor
{
    [self.servidor start];
}

- (NSString *)URLServidor
{
    return [self.servidor.serverURL absoluteString];
}

- (BOOL)mostrarBoleto:(NSDictionary *)boleto mensagemErro:(NSString **)mensagemErro
{
    NSString *codigo = boleto[@"codigo"];
    
    if (![self.servidor isRunning]) {
//        *erro = nil;
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

#pragma mark - GCDWebServerDelegate

- (void)webServerDidStart:(GCDWebServer *)server
{
    
}

- (void)webServerDidStop:(GCDWebServer *)server
{
    
}

@end
