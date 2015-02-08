//
//  BFOListaBoletosViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaBoletosViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

//View Controllers
#import "BFOEscanearBoletoViewController.h"
#import "BFOMostrarBoletoViewController.h"
#import "BFOConfiguracoesViewController.h"
#import "BFOOrdenacaoListaBoletoViewController.h"
#import "DCCNewReminderViewController.h"
#import "BFOInformarDataVencimentoViewController.h"

//Views
#import "BFOListaBoletosTableViewCell.h"

//Models
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

static NSString * const BFOBoletoActionSheetMarcarPago = @"Marcar como pago";
static NSString * const BFOBoletoActionSheetMarcarNaoPago = @"Marcar como não pago";
static NSString * const BFOBoletoActionSheetCriarLembrete = @"Criar lembrete";
static NSString * const BFOBoletoActionSheetInformarDataVencimento = @"Informar data de vencimento";

@interface BFOListaBoletosViewController () <UIActionSheetDelegate>

@property (nonatomic) NSArray *boletos;
@property (nonatomic) BFOBoleto *boletoSendoEditado;

@end

@implementation BFOListaBoletosViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UIImage *imagemEscanear = [UIImage imageNamed:@"botao_config_navbar"];
//    UIBarButtonItem *config = [[UIBarButtonItem alloc] initWithImage:imagemEscanear style:UIBarButtonItemStylePlain target:self action:@selector(abrirConfiguracao)];
//    UIBarButtonItem *adicionar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(escanearCodigo)];
//    
//    self.navigationItem.title = @"Boletos";
//    self.navigationItem.leftBarButtonItem = config;
//    self.navigationItem.rightBarButtonItem = adicionar;
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"02191618900000166510010847800017732009402163"];
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"39991611800001264300010847800017732009402163"];
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"84680000001563000820999989421070019693993499"];
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"85680000001200000820999989421070019693993499"];
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"82680000002304000820999989421070019693993499"];
//    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:@"83680000000560000820999989421070019693993499"];
    
    self.title = @"Boletos";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self carregarBoletos];
    [self.tableView reloadData];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"escanearBoletoSegue"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults integerForKey:BFONumeroBoletosLidosKey] >= 3 && ![defaults boolForKey:BFOAplicativoDesbloqueadoKey]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Obrigado por testar!" message:@"Para continuar lendo boletos, por favor desbloqueie este recurso através do menu 'Configuração', que pode ser acessado tocando no botão no canto superior esquerdo desta tela. Caso já tenha comprado o aplicativo antes, nada será cobrado pelo desbloqueio." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mostrarBoletoSegue"]) {
        BFOMostrarBoletoViewController *mostrarBoleto = segue.destinationViewController;
        
        if ([sender isKindOfClass:[BFOEscanearBoletoViewController class]]) {
            BFOEscanearBoletoViewController *escanearBoleto = sender;
            
            mostrarBoleto.boleto = escanearBoleto.boleto;
        }
        
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            mostrarBoleto.boleto = self.boletos[[self.tableView indexPathForSelectedRow].row];
        }
        
        if ([sender isKindOfClass:[BFOBoleto class]]) {
            mostrarBoleto.boleto = sender;
        }
    }
    
    if ([segue.identifier isEqualToString:@"informarDataVencimentoSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        BFOInformarDataVencimentoViewController *informarDataVencimento = (BFOInformarDataVencimentoViewController *) [navigationController topViewController];
        
        informarDataVencimento.boleto = self.boletoSendoEditado;
    }
}

#pragma mark - BFOListaBoletosViewController

- (void)carregarBoletos
{
    self.boletos = [BFOArmazenamentoBoleto sharedArmazenamentoBoleto].boletos;
    
    [self filtrarBoletos];
    
    if ([self.boletos count] == 0) {
        self.tableView.backgroundView = [[[NSBundle mainBundle] loadNibNamed:@"BFOListaBolestosVaziaView" owner:self options:nil] firstObject];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)filtrarBoletos
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *boletosIntermediario;
    
    if (![defaults boolForKey:BFOMostrarBoletosVencidosKey]) {
        self.boletos = [self.boletos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dataVencimento > %@", [NSDate date]]];
    }
    
    if (![defaults boolForKey:BFOMostrarBoletosPagosKey]) {
        self.boletos = [self.boletos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pago == 0"]];
    }
    
    switch ([defaults integerForKey:BFOOrdenacaoTelaPrincipalKey]) {
        case BFOOrdenacaoTelaPrincipalDataInsercao:
            self.boletos = [self.boletos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO],
                                                                       [NSSortDescriptor sortDescriptorWithKey:@"dataVencimento" ascending:NO]]];
            break;
            
        case BFOOrdenacaoTelaPrincipalDataVencimento:
            self.boletos = [self.boletos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"diasAteVencimento" ascending:YES],
                                                                       [NSSortDescriptor sortDescriptorWithKey:@"dataVencimento" ascending:NO]]];
            break;
            
        case BFOOrdenacaoTelaPrincipalBanco:
            boletosIntermediario = [self.boletos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"banco != %@",@"-"]];
            boletosIntermediario = [boletosIntermediario sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"banco" ascending:YES],
                                                                                       [NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]]];
            
            self.boletos = [self.boletos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"banco == %@",@"-"]];
            self.boletos = [self.boletos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO],
                                                                       [NSSortDescriptor sortDescriptorWithKey:@"dataVencimento" ascending:NO]]];
            self.boletos = [boletosIntermediario arrayByAddingObjectsFromArray:self.boletos];
            break;
            
        case BFOOrdenacaoTelaPrincipalCategoria:
            self.boletos = [self.boletos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"categoria" ascending:YES],
                                                                       [NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]]];
            break;
    }
}

//- (void)abrirConfiguracao
//{
//    BFOConfiguracoesViewController *configuracoes = [BFOConfiguracoesViewController new];
//    UINavigationController *navegacao = [[UINavigationController alloc] initWithRootViewController:configuracoes];
//    
//    [self presentViewController:navegacao animated:YES completion:nil];
//}
//
//- (void)escanearCodigo
//{
//    [self presentViewController:[BFOEscanearBoletoViewController new] animated:YES completion:nil];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.boletos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOListaBoletosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BFOListaBoletosTableViewCell" forIndexPath:indexPath];
    BFOBoleto *boleto = self.boletos[indexPath.row];
    
    [cell configurarTableViewCellComBoleto:boleto];
    
    if ([boleto.pago boolValue]) {
        [cell marcarComoPago];
    } else {
        [cell marcarComoNaoPago];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOBoleto *boleto = self.boletos[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] removerBoleto:boleto];
        [self carregarBoletos];
        
        [self setEditing:NO animated:NO];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//Private API
- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Mais";
}

//Private API
- (void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOBoleto *boleto = self.boletos[indexPath.row];
    UIActionSheet *boletoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    if ([boleto.pago boolValue]) {
        [boletoActionSheet addButtonWithTitle:BFOBoletoActionSheetMarcarNaoPago];
    } else {
        [boletoActionSheet addButtonWithTitle:BFOBoletoActionSheetMarcarPago];
    }
    
    if (!boleto.dataVencimento) {
        [boletoActionSheet addButtonWithTitle:BFOBoletoActionSheetInformarDataVencimento];
    }
    
    [boletoActionSheet addButtonWithTitle:BFOBoletoActionSheetCriarLembrete];
    
    [boletoActionSheet addButtonWithTitle:@"Cancelar"];
    boletoActionSheet.cancelButtonIndex = boletoActionSheet.numberOfButtons - 1;
    
    [boletoActionSheet showInView:self.tableView];
    
    self.boletoSendoEditado = boleto;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BFOListaBoletosTableViewCell *cell;
    NSIndexPath *indexPath;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:BFOBoletoActionSheetMarcarPago] ||
        [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:BFOBoletoActionSheetMarcarNaoPago]) {
        [self.boletoSendoEditado alternaPago];
        [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
        
        indexPath = [NSIndexPath indexPathForItem:[self.boletos indexOfObject:self.boletoSendoEditado] inSection:0];
        
        if ([defaults boolForKey:BFOMostrarBoletosPagosKey]) {
            cell = (BFOListaBoletosTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            
            if ([self.boletoSendoEditado.pago boolValue]) {
                [cell marcarComoPago];
            } else {
                [cell marcarComoNaoPago];
            }
        } else {
            [self carregarBoletos];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:BFOBoletoActionSheetInformarDataVencimento]) {
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[BFOInformarDataVencimentoViewController alloc] initWithBoleto:self.boletoSendoEditado]] animated:YES completion:nil];
        [self performSegueWithIdentifier:@"informarDataVencimentoSegue" sender:self];
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:BFOBoletoActionSheetCriarLembrete]) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[DCCNewReminderViewController alloc] initWithBoleto:self.boletoSendoEditado]] animated:YES completion:nil];
    }
    
    self.boletoSendoEditado = nil;
    [self setEditing:NO animated:YES];
}

@end
