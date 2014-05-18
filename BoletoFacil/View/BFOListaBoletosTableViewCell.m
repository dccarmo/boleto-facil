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
@property (weak, nonatomic) IBOutlet UIView *segmento;

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
        self.titulo.text = boleto.segmento;
    }
    
    if (boleto.dataVencimento) {
        self.descricao.text = [NSString stringWithFormat:@"%@ - %@", boleto.valorExtenso, [formatoData stringFromDate:boleto.dataVencimento]];
    } else {
        self.descricao.text = boleto.valorExtenso;
    }

    switch ([boleto.codigoSegmento integerValue]) {
        case 1:
            self.segmento.backgroundColor = [UIColor colorWithRed:1 green:0.647 blue:0.007 alpha:1];
            break;
            
        case 2:
            self.segmento.backgroundColor = [UIColor colorWithRed:0 green:0.568 blue:1 alpha:1];
            break;
            
        case 3:
            self.segmento.backgroundColor = [UIColor colorWithRed:1 green:0.823 blue:0.007 alpha:1];
            break;
            
        case 4:
            self.segmento.backgroundColor = [UIColor colorWithRed:0.415 green:0.443 blue:0.894 alpha:1];
            break;
            
        case 5:
            self.segmento.backgroundColor = [UIColor colorWithRed:1 green:0.647 blue:0.007 alpha:1];
            break;
            
        case 7:
            self.segmento.backgroundColor = [UIColor colorWithRed:0.38 green:0.823 blue:0.996 alpha:1];
            break;
            
        default:
            self.segmento.backgroundColor = [UIColor colorWithRed:0.282 green:0.858 blue:0.419 alpha:1];
            break;
    }
}

@end
