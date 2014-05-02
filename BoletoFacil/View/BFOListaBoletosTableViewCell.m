//
//  BFOListaBoletosTableViewCell.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 02/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaBoletosTableViewCell.h"

@interface BFOListaBoletosTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *banco;
@property (weak, nonatomic) IBOutlet UILabel *data;
@property (weak, nonatomic) IBOutlet UILabel *codigo;

@end

@implementation BFOListaBoletosTableViewCell

- (void)configurarCelularComCodigoBarra:(NSDictionary *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    formatoData.dateStyle = NSDateFormatterShortStyle;
    
    self.codigo.text = boleto[@"codigo"];
    self.data.text = [formatoData stringFromDate:boleto[@"data"]];
}

@end
