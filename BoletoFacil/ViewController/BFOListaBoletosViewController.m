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

//Views
#import "BFOListaBoletosTableViewCell.h"

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
    
    self.navigationItem.rightBarButtonItem = botaoCamera;
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"BFOListaBoletosTableViewCell" bundle:nil] forCellReuseIdentifier:@"BFOListaBoletosTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    if (![self.gerenciadorCodigoBarra quantidadeCodigosArmazenados]) {
        self.tableView.backgroundView = [[[NSBundle mainBundle] loadNibNamed:@"BFOListaBolestosVaziaView" owner:self options:nil] firstObject];
    } else {
        self.tableView.backgroundView = nil;
    }
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
    BFOListaBoletosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BFOListaBoletosTableViewCell" forIndexPath:indexPath];
    NSDictionary *codigoBarra = [self.gerenciadorCodigoBarra codigoNoIndice:indexPath.row];
    
    [cell configurarCelularComCodigoBarra:codigoBarra];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *codigoBarrra = [self.gerenciadorCodigoBarra codigoNoIndice:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[BFOMostrarBoletoViewController alloc] initWithCodigoBarra:codigoBarrra] animated:YES];
}

@end
