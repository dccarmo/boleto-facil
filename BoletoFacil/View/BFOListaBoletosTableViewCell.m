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
@property (weak, nonatomic) IBOutlet UILabel *data;
@property (weak, nonatomic) IBOutlet UILabel *codigo;

@end

@implementation BFOListaBoletosTableViewCell

- (void)configurarTableViewCellComBoleto:(BFOBoleto *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDoesRelativeDateFormatting:YES];
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    
    self.banco.text = boleto.banco;
    self.codigo.text = boleto.linhaDigitavel;
    self.data.text = [formatoData stringFromDate:boleto.data];
}

@end
