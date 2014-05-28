//
//  BFOListaBoletosTableViewCell.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaBoletosTableViewCell.h"

//Views
#import "BFOListaBoletosActionButtonsView.h"

//Models
#import "BFOBoleto.h"

@interface BFOListaBoletosTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *descricao;
@property (weak, nonatomic) IBOutlet UIView *corCategoria;

@end

@implementation BFOListaBoletosTableViewCell

#pragma mark - BFOListaBoletosTableViewCell

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

- (void)marcarComoPago
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.titulo.text];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@1
                            range:NSMakeRange(0, [attributeString length])];
    
    self.titulo.attributedText = attributeString;
    self.titulo.textColor = [UIColor lightGrayColor];
}

- (void)marcarComoNaoPago
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.titulo.text];
    
    self.titulo.attributedText = attributeString;
    self.titulo.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

@end
