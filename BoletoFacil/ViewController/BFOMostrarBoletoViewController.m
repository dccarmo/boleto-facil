//
//  BFOMostrarBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOMostrarBoletoViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

//View Controllers
#import "BFOListaBoletosViewController.h"

//Views
#import "BFOMostrarBoletoView.h"

//Models
#import "BFOBoleto.h"

//Support
#import "BFOServidorInternet.h"
#import "BFOArmazenamentoBoleto.h"

@interface BFOMostrarBoletoViewController ()

@property (nonatomic) BOOL dataVencimentoRelativa;
@property (weak, nonatomic) IBOutlet UITextField *titulo;

@end

@implementation BFOMostrarBoletoViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Detalhe";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    
    [view configurarViewComBoleto:self.boleto];
    [view alterarEstadoCriacaoServidor:BFOEstadoCriacaoServidorIniciando mensagem:@"Carregando servidor..."];
    
    self.dataVencimentoRelativa = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adicionarAcessoWeb];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:BFONenhumBoletoVisualizadoKey]) {
        NSString *title = @"Ajuda";
        NSString *message = @"Aqui você tem todas as informações que o aplicativo conseguiu extrair do código de barras. Para acessá-las no seu computador, digite o endereço que aparece no quadro verde.";
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Entendi" style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Entendi", nil];
            [alertView show];
        }
    }
    
    [userDefaults setObject:@NO forKey:BFONenhumBoletoVisualizadoKey];
    [userDefaults synchronize];
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

- (IBAction)compartilharBoletoAction:(id)sender
{
    UIActivityViewController *opcoesCompartilhamento;
    
    opcoesCompartilhamento = [[UIActivityViewController alloc] initWithActivityItems:@[self.boleto] applicationActivities:nil];
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

- (IBAction)mudouTitulo:(id)sender {
    [self.boleto alteraTitulo:self.titulo.text];
    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
}

@end
