//
//  BFOConfiguracoesViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 15/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOConfiguracoesViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

//View Controllers
#import "BFOOrdenacaoListaBoletoViewController.h"
#import "BFOListaLembretesViewController.h"

typedef NS_ENUM(NSUInteger, BFOConfiguracoesViewControllerSecao)
{
    BFOConfiguracoesViewControllerSecaoTelaPrincipal,
    BFOConfiguracoesViewControllerSecaoLembretes
};

@interface BFOConfiguracoesViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *mostrarBoletosVencidos;
@property (weak, nonatomic) IBOutlet UISwitch *mostrarBoletosPagos;

@end

@implementation BFOConfiguracoesViewController

- (instancetype)init
{
    UIStoryboard* configuracoesStoryboard = [UIStoryboard storyboardWithName:@"BFOConfiguracoes" bundle:nil];
    
    self = [configuracoesStoryboard instantiateInitialViewController];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configurarInterruptores];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - BFOConfiguracoesViewController

- (void)configurarInterruptores
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.mostrarBoletosVencidos.on = [defaults boolForKey:BFOMostrarBoletosVencidosKey];
    self.mostrarBoletosPagos.on = [defaults boolForKey:BFOMostrarBoletosPagosKey];
}

- (IBAction)fechar:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mostrarBoletosVencidosAction:(id)sender
{
    UISwitch *interruptor = (UISwitch *) sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@(interruptor.on) forKey:BFOMostrarBoletosVencidosKey];
}

- (IBAction)mostrarBoletosPagosAction:(id)sender
{
    UISwitch *interruptor = (UISwitch *) sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@(interruptor.on) forKey:BFOMostrarBoletosPagosKey];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == BFOConfiguracoesViewControllerSecaoTelaPrincipal &&
        indexPath.row == 0) {
        switch ([defaults integerForKey:BFOOrdenacaoTelaPrincipalKey]) {
            case BFOOrdenacaoTelaPrincipalDataInsercao:
                cell.detailTextLabel.text = BFOOrdenacaoTelaPrincipalDataInsercaoTexto;
                break;
                
            case BFOOrdenacaoTelaPrincipalDataVencimento:
                cell.detailTextLabel.text = BFOOrdenacaoTelaPrincipalDataVencimentoTexto;
                break;
                
            case BFOOrdenacaoTelaPrincipalCategoria:
                cell.detailTextLabel.text = BFOOrdenacaoTelaPrincipalCategoriaTexto;
                break;
                
            case BFOOrdenacaoTelaPrincipalBanco:
                cell.detailTextLabel.text = BFOOrdenacaoTelaPrincipalBancoTexto;
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == BFOConfiguracoesViewControllerSecaoTelaPrincipal ) {
//        [self.navigationController pushViewController:[BFOOrdenacaoListaBoletoViewController new] animated:YES];
//    }
//    
//    if (indexPath.section == BFOConfiguracoesViewControllerSecaoLembretes) {
//        [self.navigationController pushViewController:[BFOListaLembretesViewController new] animated:YES];
//    }
//}

@end
