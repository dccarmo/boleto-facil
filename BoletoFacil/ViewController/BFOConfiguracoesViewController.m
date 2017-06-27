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

//Pods
#import <RMStore.h>
#import <RMAppReceipt.h>
#import <RMStoreAppReceiptVerificator.h>

typedef NS_ENUM(NSUInteger, BFOConfiguracoesViewControllerSecao)
{
    BFOConfiguracoesViewControllerSecaoTelaPrincipal,
    BFOConfiguracoesViewControllerSecaoLembretes
};

@interface BFOConfiguracoesViewController() <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *comprarButton;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:AlreadyPurchasedKey]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.title = @"Configurações";
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

- (void)desbloquearAplicativo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(YES) forKey:AlreadyPurchasedKey];
    [defaults synchronize];
    
    self.navigationItem.rightBarButtonItem = nil;
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

- (IBAction)comprarButtonAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Desbloquear" message:@"Obrigado pelo seu interesse no Zebra! Caso já tenha comprado o aplicativo antes, escolha 'Restaurar'. Ou toque em 'Comprar' para desbloquear a leituras de boletos." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Comprar", @"Restaurar", nil];
    [alertView show];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Comprar"]) {
        [[RMStore defaultStore] requestProducts:[NSSet setWithArray:@[IAPUnlockProductIdentifier]] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            [[RMStore defaultStore] addPayment:IAPUnlockProductIdentifier success:^(SKPaymentTransaction *transaction) {
                [self desbloquearAplicativo];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucesso!" message:@"Obrigado por ter comprado o Zebra! :)" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
                [alertView show];
            } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Restaurar"]) {
        [[RMStore defaultStore] requestProducts:[NSSet setWithArray:@[IAPUnlockProductIdentifier]] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            [[RMStore defaultStore] refreshReceiptOnSuccess:^{
                [self desbloquearAplicativo];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucesso!" message:@"Obrigado por ter comprado o Zebra! :)" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
                [alertView show];
            } failure:^(NSError *error) {
                [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
                    [self desbloquearAplicativo];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucesso!" message:@"Obrigado por ter comprado o Zebra! :)" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
                    [alertView show];
                } failure:^(NSError *error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }];
            }];
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
}

@end
