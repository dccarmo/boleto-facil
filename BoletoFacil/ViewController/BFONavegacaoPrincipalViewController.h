//
//  BFONavegacaoPrincipalViewController.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFOBoleto;

@interface BFONavegacaoPrincipalViewController : UINavigationController

- (void)mostrarBoleto:(BFOBoleto *)boleto;

@end
