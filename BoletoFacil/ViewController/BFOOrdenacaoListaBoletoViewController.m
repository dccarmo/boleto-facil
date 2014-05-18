//
//  BFOOrdenacaoListaBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 18/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOOrdenacaoListaBoletoViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

static const NSUInteger quantidadeOpcoes = 4;

NSString * const BFOOrdenacaoTelaPrincipalDataInsercaoTexto = @"Data de inserção";
NSString * const BFOOrdenacaoTelaPrincipalDataVencimentoTexto = @"Data de vencimento";
NSString * const BFOOrdenacaoTelaPrincipalCategoriaTexto = @"Categoria";
NSString * const BFOOrdenacaoTelaPrincipalBancoTexto = @"Banco";

@interface BFOOrdenacaoListaBoletoViewController ()

@end

@implementation BFOOrdenacaoListaBoletoViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"Ordenar por";
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return quantidadeOpcoes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    switch (indexPath.row) {
        case BFOOrdenacaoTelaPrincipalDataInsercao:
            cell.textLabel.text = BFOOrdenacaoTelaPrincipalDataInsercaoTexto;
            break;
            
        case BFOOrdenacaoTelaPrincipalDataVencimento:
            cell.textLabel.text = BFOOrdenacaoTelaPrincipalDataVencimentoTexto;
            break;
            
        case BFOOrdenacaoTelaPrincipalCategoria:
            cell.textLabel.text = BFOOrdenacaoTelaPrincipalCategoriaTexto;
            break;
            
        case BFOOrdenacaoTelaPrincipalBanco:
            cell.textLabel.text = BFOOrdenacaoTelaPrincipalBancoTexto;
            break;
    }
    
    if (indexPath.row == [defaults integerForKey:BFOOrdenacaoTelaPrincipalKey]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [defaults setObject:[NSNumber numberWithInteger:indexPath.row] forKey:BFOOrdenacaoTelaPrincipalKey];
    
    [self.tableView reloadData];
}


@end
