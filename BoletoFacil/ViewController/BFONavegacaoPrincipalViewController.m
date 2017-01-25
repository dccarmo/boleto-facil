//
//  BFONavegacaoPrincipalViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFONavegacaoPrincipalViewController.h"

//View Controllers
#import "BFOListaBoletosViewController.h"
#import "BFOMostrarBoletoViewController.h"

//Pods
#import "GAITrackedViewController.h"

@interface BFONavegacaoPrincipalViewController ()

@end

@implementation BFONavegacaoPrincipalViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationBar.translucent = NO;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - BFONavegacaoPrincipalViewController

- (void)mostrarBoleto:(BFOBoleto *)boleto
{
    [self.topViewController performSegueWithIdentifier:@"mostrarBoletoSegue" sender:boleto];
}

@end
