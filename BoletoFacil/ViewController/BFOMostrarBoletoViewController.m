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
#import "BFOAdicionarLembreteActivity.h"

//Models
#import "BFOBoleto.h"

//Support
#import "BFOServidorInternet.h"

@interface BFOMostrarBoletoViewController ()

@property (nonatomic) BFOBoleto *boleto;
@property (nonatomic) BOOL dataVencimentoRelativa;

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
    
    self.dataVencimentoRelativa = YES;
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
        [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorAviso mensagem:mensagemErro];
    }
}

- (void)compartilharBoleto
{
    BFOAdicionarLembreteActivity *adicionarLembrete;
    UIActivityViewController *opcoesCompartilhamento;
    
    adicionarLembrete = [[BFOAdicionarLembreteActivity alloc] initWithBoleto:self.boleto];
    
    if ([[UIApplication sharedApplication].scheduledLocalNotifications count] < 64) {
        opcoesCompartilhamento = [[UIActivityViewController alloc] initWithActivityItems:@[self.boleto] applicationActivities:@[adicionarLembrete]];
    } else {
        opcoesCompartilhamento = [[UIActivityViewController alloc] initWithActivityItems:@[self.boleto] applicationActivities:nil];
    }
    
    opcoesCompartilhamento.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo];
    
    [self presentViewController:opcoesCompartilhamento animated:YES completion:nil];
}

- (IBAction)trocarDataValidadeAction:(UITapGestureRecognizer *)toque
{
    UILabel *dataVencimento = (UILabel *) toque.view;
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    self.dataVencimentoRelativa = !self.dataVencimentoRelativa;
    
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    [formatoData setDoesRelativeDateFormatting:self.dataVencimentoRelativa];
    
    dataVencimento.text = [formatoData stringFromDate:self.boleto.dataVencimento];
}

@end
