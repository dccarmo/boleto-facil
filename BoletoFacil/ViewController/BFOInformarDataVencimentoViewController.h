//
//  BFODataVencimentoViewController.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 25/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFOBaseTableViewController.h"

@class BFOBoleto;

@interface BFOInformarDataVencimentoViewController : BFOBaseTableViewController

@property (nonatomic) BFOBoleto *boleto;

//- (instancetype)initWithBoleto:(BFOBoleto *)boleto;

@end
