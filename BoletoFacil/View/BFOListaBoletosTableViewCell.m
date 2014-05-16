//
//  BFOListaBoletosTableViewCell.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaBoletosTableViewCell.h"

//Models
#import "BFOBoleto.h"

@interface BFOListaBoletosTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *banco;
@property (weak, nonatomic) IBOutlet UILabel *codigo;

@end

@implementation BFOListaBoletosTableViewCell

- (void)configurarTableViewCellComBoleto:(BFOBoleto *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDoesRelativeDateFormatting:YES];
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    
    if (boleto.tipo == BFOTipoBoletoBancario) {
        self.banco.text = boleto.banco;
    } else {
        self.banco.text = boleto.segmento;
    }

    self.codigo.text = [boleto linhaDigitavelFormatada];
}

@end
