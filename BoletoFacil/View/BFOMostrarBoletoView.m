//
//  BFOMostrarBoletoView.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 28/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOMostrarBoletoView.h"

@interface BFOMostrarBoletoView ()

@property (weak, nonatomic) IBOutlet UIView *estadoServidorFundo;
@property (weak, nonatomic) IBOutlet UILabel *estadoServidorMensagem;
@property (weak, nonatomic) IBOutlet UIScrollView *codigoBarras;

@property (weak, nonatomic) IBOutlet UILabel *banco;
@property (weak, nonatomic) IBOutlet UILabel *dataVencimento;
@property (weak, nonatomic) IBOutlet UILabel *valor;
@property (weak, nonatomic) IBOutlet UIScrollView *containerCodigo;

@end

@implementation BFOMostrarBoletoView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)alterarEstadoCriacaoServidor:(BFOEstadoCriacaoServidor)estado mensagem:(NSString *)mensagem
{
    [UIView beginAnimations:@"alterarEstadoCriacaoServidor" context:nil];
    
    switch (estado) {
        case BFOEstadoCriacaoServidorIniciando:
            self.estadoServidorFundo.backgroundColor = [UIColor colorWithRed:0.443 green:0.874 blue:0.98 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorSucesso:
            self.estadoServidorFundo.backgroundColor = [UIColor colorWithRed:0.298 green:0.85 blue:0.392 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorAviso:
            self.estadoServidorFundo.backgroundColor = [UIColor colorWithRed:1 green:0.8 blue:0.007 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorFalha:
            self.estadoServidorFundo.backgroundColor = [UIColor colorWithRed:1 green:0.176 blue:0.333 alpha:1];
            break;
    }
    
    self.estadoServidorMensagem.text = mensagem;
    
    [UIView commitAnimations];
}

- (void)configurarViewComBoleto:(NSDictionary *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    [formatoData setDoesRelativeDateFormatting:YES];
    
    self.banco.text = boleto[@"banco"];
    self.dataVencimento.text = [formatoData stringFromDate:boleto[@"dataVencimento"]];
    self.valor.text = boleto[@"valorExtenso"];
}

@end
