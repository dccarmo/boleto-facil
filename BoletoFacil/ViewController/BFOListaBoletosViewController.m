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

//Models
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

@interface BFOListaBoletosViewController ()

@end

@implementation BFOListaBoletosViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOListaBoletosView" bundle:nil];
    if (self) {
        UIImage *imagemEscanear = [UIImage imageNamed:@"botao_config_navbar"];
        UIBarButtonItem *config = [[UIBarButtonItem alloc] initWithImage:imagemEscanear style:UIBarButtonItemStyleDone target:self action:@selector(abrirConfiguracao)];
        UIBarButtonItem *adicionar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(escanearCodigo)];
        
        self.navigationItem.title = @"Boletos";
        self.navigationItem.leftBarButtonItem = config;
        self.navigationItem.rightBarButtonItem = adicionar;
        
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self init];
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"BFOListaBoletosTableViewCell" bundle:nil] forCellReuseIdentifier:@"BFOListaBoletosTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    if ([[BFOArmazenamentoBoleto sharedArmazenamentoBoleto].boletos count] == 0) {
        self.tableView.backgroundView = [[[NSBundle mainBundle] loadNibNamed:@"BFOListaBolestosVaziaView" owner:self options:nil] firstObject];
    } else {
        self.tableView.backgroundView = nil;
    }
}

#pragma mark - BFOListaBoletosViewController

- (void)abrirConfiguracao
{
    
}

- (void)escanearCodigo
{
    [self presentViewController:[BFOEscanearBoletoViewController new] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto].boletos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOListaBoletosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BFOListaBoletosTableViewCell" forIndexPath:indexPath];
    BFOBoleto *boleto = [BFOArmazenamentoBoleto sharedArmazenamentoBoleto].boletos[indexPath.row];
    
    [cell configurarTableViewCellComBoleto:boleto];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOBoleto *boleto = [BFOArmazenamentoBoleto sharedArmazenamentoBoleto].boletos[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[BFOMostrarBoletoViewController alloc] initWithBoleto:boleto] animated:YES];
}

@end
