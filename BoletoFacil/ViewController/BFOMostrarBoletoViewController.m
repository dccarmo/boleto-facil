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

//Models
#import "BFOBoleto.h"

//Support
#import "DCCBoletoBancarioFormatter.h"
#import "BFOServidorInternet.h"

@interface BFOMostrarBoletoViewController ()

@property (nonatomic) BFOBoleto *boleto;

@end

@implementation BFOMostrarBoletoViewController

- (instancetype)initWithBoleto:(BFOBoleto *)boleto
{
    self = [super initWithNibName:@"BFOMostrarBoletoView" bundle:nil];
    if (self) {
        UIBarButtonItem *botaoCompartilhar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(compartilharBoleto)];
        
        self.navigationItem.title = @"Detalhe";
        self.navigationItem.rightBarButtonItem = botaoCompartilhar;
        
        self.boleto = boleto;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithBoleto:nil];
    return self;
}

#pragma mark - UIViewController

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

#pragma mark - BFOMostrarBoletoViewController

- (void)adicionarAcessoWeb
{
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    NSString *mensagemErro;
    
    if ([[BFOServidorInternet sharedServidorInternet] mostrarBoleto:self.boleto mensagemErro:&mensagemErro]) {
        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorSucesso mensagem:[[BFOServidorInternet sharedServidorInternet] URLServidor]];
    } else {
        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorFalha mensagem:mensagemErro];
    }
}

- (void)compartilharBoleto
{
    UIActivityViewController *opcoesCompartilhamento = [[UIActivityViewController alloc] initWithActivityItems:@[self.boleto] applicationActivities:@[]];
    
    opcoesCompartilhamento.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo];
    
    [self presentViewController:opcoesCompartilhamento animated:YES completion:nil];
}

@end
