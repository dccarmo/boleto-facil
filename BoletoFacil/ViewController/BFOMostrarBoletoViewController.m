//
//  BFOMostrarBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOMostrarBoletoViewController.h"

//View Controllers
#import "BFOListaBoletosViewController.h"

//Views
#import "BFOMostrarBoletoView.h"

//Support
#import "DCCBoletoBancarioFormatter.h"
#import "BFOServidorInternet.h"

@interface BFOMostrarBoletoViewController ()

@property (nonatomic) NSDictionary *boleto;

@end

@implementation BFOMostrarBoletoViewController

- (instancetype)initWithCodigoBarra:(NSDictionary *)boleto
{
    self = [super initWithNibName:@"BFOMostrarBoletoView" bundle:nil];
    if (self) {
        self.navigationItem.title = @"Detalhe Boleto";
        
        self.boleto = boleto;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    
    [view configurarViewComBoleto:self.boleto];
    [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorIniciando mensagem:@"Carregando servidor..."];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self adicionarAcessoWeb];
}

- (void)adicionarAcessoWeb
{
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    NSString *mensagemErro;
    
    if ([[BFOServidorInternet sharedServidorInternet] mostrarBoleto:self.boleto mensagemErro:&mensagemErro]) {
        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorSucesso mensagem:[[BFOServidorInternet sharedServidorInternet] URLServidor]];
    }
    
//    if ([self.servidorWeb isRunning]) {
//        [self.servidorWeb addDefaultHandlerForMethod:@"GET"
//                                              requestClass:[GCDWebServerRequest class]
//                                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
//                                                  
//                                                  return [GCDWebServerDataResponse responseWithHTML:[NSString stringWithFormat:@"<html><body><p>Seu código de barras é: %@</p></body></html>", [formatoLinhaDigitavel linhaDigitavelDoCodigoBarra:codigo]]];
//                                              }];
//        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorSucesso mensagem:[self.servidorWeb.serverURL absoluteString]];
//    } else {
//        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorFalha mensagem:@"Erro ao criar acesso web"];
//    }
}

@end
