//
//  BFOOrdenacaoListaBoletoViewController.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 18/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFOBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, BFOOrdenacaoTelaPrincipal)
{
    BFOOrdenacaoTelaPrincipalDataInsercao,
    BFOOrdenacaoTelaPrincipalDataVencimento,
    BFOOrdenacaoTelaPrincipalCategoria,
    BFOOrdenacaoTelaPrincipalBanco
};

extern NSString * const BFOOrdenacaoTelaPrincipalDataInsercaoTexto;
extern NSString * const BFOOrdenacaoTelaPrincipalDataVencimentoTexto;
extern NSString * const BFOOrdenacaoTelaPrincipalCategoriaTexto;
extern NSString * const BFOOrdenacaoTelaPrincipalBancoTexto;

@interface BFOOrdenacaoListaBoletoViewController : BFOBaseTableViewController

@end
