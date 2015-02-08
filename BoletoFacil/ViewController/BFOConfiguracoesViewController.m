//
//  BFOConfiguracoesViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 15/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOConfiguracoesViewController.h"
#import <StoreKit/StoreKit.h>

//App Delegate
#import "BFOAppDelegate.h"

//View Controllers
#import "BFOOrdenacaoListaBoletoViewController.h"
#import "BFOListaLembretesViewController.h"

#define kRemoveAdsProductIdentifier @"me.dcarmo.zebra.unlock"

typedef NS_ENUM(NSUInteger, BFOConfiguracoesViewControllerSecao)
{
    BFOConfiguracoesViewControllerSecaoTelaPrincipal,
    BFOConfiguracoesViewControllerSecaoLembretes
};

@interface BFOConfiguracoesViewController() <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>

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
    if ([defaults boolForKey:BFOAplicativoDesbloqueadoKey]) {
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
    [defaults setObject:@(YES) forKey:BFOAplicativoDesbloqueadoKey];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Desbloquear" message:@"Obrigado pelo seu interesse no Zebra! Caso já tenha comprado o aplicativo antes, escolha 'Restaurar'. Ou toque em 'Comprar' para desbloquear o número de leituras de boletos." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Comprar", @"Restaurar", nil];
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

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if (count > 0) {
        validProduct = [response.products objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else if (!validProduct) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Erro interno" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStatePurchased:
                [self desbloquearAplicativo];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    for (SKPaymentTransaction *transaction in queue.transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateRestored || transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self desbloquearAplicativo];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            
            return;
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro ao restaurar a compra" message:@"Nenhuma compra anterior foi encontrada" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Comprar"]) {
            if ([SKPaymentQueue canMakePayments]) {
                SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
                productsRequest.delegate = self;
                [productsRequest start];
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Não foi possível comprar" message:@"Você não está autorizado a realizar transações" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
        
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Restaurar"]) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
    }
}

@end
