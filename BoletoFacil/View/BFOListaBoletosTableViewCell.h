//
//  BFOListaBoletosTableViewCell.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFOBoleto;

@interface BFOListaBoletosTableViewCell : UITableViewCell

- (void)configurarTableViewCellComBoleto:(BFOBoleto *)boleto;
- (void)marcarComoPago;
- (void)marcarComoNaoPago;

@end
