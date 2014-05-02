//
//  BFOListaBoletosViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaBoletosViewController.h"

//View Controllers
#import "BFOEscanearBoletoViewController.h"
#import "BFOMostrarBoletoViewController.h"

//Model
#import "BFOGerenciadorCodigoBarra.h"

@interface BFOListaBoletosViewController ()

@property (nonatomic) BFOGerenciadorCodigoBarra *gerenciadorCodigoBarra;

@end

@implementation BFOListaBoletosViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOListaBoletosView" bundle:nil];
    if (self) {
        self.gerenciadorCodigoBarra = [BFOGerenciadorCodigoBarra sharedGerenciadorCodigoBarra];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *botaoCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(escanearCodigo)];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.rightBarButtonItem = botaoCamera;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)escanearCodigo
{
    [self presentViewController:[BFOEscanearBoletoViewController new] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gerenciadorCodigoBarra quantidadeCodigosArmazenados];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDictionary *barCode = [self.gerenciadorCodigoBarra codigoNoIndice:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = barCode[@"codigo"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *codigoBarrra = [self.gerenciadorCodigoBarra codigoNoIndice:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[BFOMostrarBoletoViewController alloc] initWithCodigoBarra:codigoBarrra] animated:YES];
}

@end
