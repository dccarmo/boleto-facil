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

@interface BFONavegacaoPrincipalViewController ()

@end

@implementation BFONavegacaoPrincipalViewController

- (instancetype)init
{
    BFOListaBoletosViewController *listaBoletos = [BFOListaBoletosViewController new];
    
    self = [super initWithRootViewController:listaBoletos];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
