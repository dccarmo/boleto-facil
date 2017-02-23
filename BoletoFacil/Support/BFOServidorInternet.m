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
}

- (NSString *)URLServidor
{
    return [self.servidor.serverURL absoluteString];
}

- (BOOL)mostrarBoleto:(BFOBoleto *)boleto mensagemErro:(NSString **)mensagemErro
{
    NSString *html;
    
    if ([self.servidor isRunning]) {
        [self.servidor stop];
    }
    
    html = [self HTMLFormatadoComBoleto:boleto];
    
    [self.servidor removeAllHandlers];
    
    [self.servidor addDefaultHandlerForMethod:@"GET"
                                 requestClass:[GCDWebServerRequest class]
                                 processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                     
                                     return [GCDWebServerDataResponse responseWithHTML:html];
                                 }];
    
    [self.servidor start];
    
    return YES;
}

- (NSString *)HTMLFormatadoComBoleto:(BFOBoleto *)boleto
{
    NSString *html = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BFOBoletoHTML" ofType:@"html"] usedEncoding:nil error:nil];
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    [formatoData setDoesRelativeDateFormatting:YES];
    
    html = [html stringByReplacingOccurrencesOfString:@"%@TITULO@%" withString:@"Zebra"];
    
    if (boleto.titulo && [boleto.titulo length] > 0) {
        html = [html stringByReplacingOccurrencesOfString:@"%@TITULO-BOLETO@%" withString:boleto.titulo];
    } else {
        html = [html stringByReplacingOccurrencesOfString:@"%@TITULO-BOLETO@%" withString:@"Sem título"];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"%@CATEGORIA@%" withString:boleto.categoria];
    html = [html stringByReplacingOccurrencesOfString:@"%@BANCO@%" withString:boleto.banco];
    
    if (boleto.dataVencimento) {
        html = [html stringByReplacingOccurrencesOfString:@"%@DATA-VENCIMENTO@%" withString:[formatoData stringFromDate:boleto.dataVencimento]];
    } else {
        html = [html stringByReplacingOccurrencesOfString:@"%@DATA-VENCIMENTO@%" withString:@"-"];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"%@VALOR@%" withString:boleto.valorExtenso];
    
    html = [html stringByReplacingOccurrencesOfString:@"%@LINHA-DIGITAVEL-FORMATADA@%" withString:boleto.linhaDigitavelFormatada];
    html = [html stringByReplacingOccurrencesOfString:@"%@LINHA-DIGITAVEL@%" withString:boleto.linhaDigitavel];
    
    html = [html stringByReplacingOccurrencesOfString:@"%@CODIGO-BARRA@%" withString:boleto.codigoBarras];
    
    return html;
}

#pragma mark - NSNotificationCenter

- (void)reachabilityMudou
{
    if (self.reachability.currentReachabilityStatus != ReachableViaWiFi) {
        self.mensagemErro = erroSemConexaoWifi;
    }
}

@end
