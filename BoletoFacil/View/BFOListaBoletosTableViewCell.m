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

@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *descricao;
@property (weak, nonatomic) IBOutlet UIView *corCategoria;

@end

@implementation BFOListaBoletosTableViewCell

- (void)configurarTableViewCellComBoleto:(BFOBoleto *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDoesRelativeDateFormatting:YES];
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    
    if (boleto.tipo == BFOTipoBoletoBancario) {
        self.titulo.text = boleto.banco;
    } else {
        self.titulo.text = boleto.categoria;
    }
    
    if (boleto.dataVencimento) {
        self.descricao.text = [NSString stringWithFormat:@"%@ - %@", boleto.valorExtenso, [formatoData stringFromDate:boleto.dataVencimento]];
    } else {
        self.descricao.text = boleto.valorExtenso;
    }
    
    self.corCategoria.backgroundColor = boleto.corCategoria;
}

@end
