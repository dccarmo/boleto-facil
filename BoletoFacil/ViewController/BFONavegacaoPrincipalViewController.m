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

@interface BFONavegacaoPrincipalViewController ()

@end

@implementation BFONavegacaoPrincipalViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationBar.translucent = NO;
}

//- (instancetype)init
//{
//    BFOListaBoletosViewController *listaBoletos = [BFOListaBoletosViewController new];
//    
//    self = [super initWithRootViewController:listaBoletos];
//    if (self) {
//        self.navigationBar.translucent = NO;
//    }
//    return self;
//}
//
//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
//{
//    self = [self init];
//    return self;
//}

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
