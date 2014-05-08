//
//  BFOMostrarBoletoView.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 28/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOMostrarBoletoView.h"

//Views
#import "BFOSequenciaLabel.h"

//Models
#import "BFOBoleto.h"

static const NSUInteger margemNumerosLinhaDigitavel = 15;
static const NSUInteger margemLateralView = 20;

@interface BFOMostrarBoletoView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *estadoServidorFundo;
@property (weak, nonatomic) IBOutlet UILabel *estadoServidorMensagem;

@property (weak, nonatomic) IBOutlet UILabel *banco;
@property (weak, nonatomic) IBOutlet UILabel *dataVencimento;
@property (weak, nonatomic) IBOutlet UILabel *valor;
@property (weak, nonatomic) IBOutlet UIScrollView *containerLinhaDigitavel;
@property (weak, nonatomic) IBOutlet UIScrollView *containerCodigoBarras;

@end

@implementation BFOMostrarBoletoView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

#pragma mark - BFOMostrarBoletoView

- (void)alterarEstadoCriacaoServidor:(BFOEstadoCriacaoServidor)estado mensagem:(NSString *)mensagem
{
    [UIView beginAnimations:@"alterarEstadoCriacaoServidor" context:nil];
    
    switch (estado) {
        case BFOEstadoCriacaoServidorIniciando:
            self.estadoServidorFundo.backgroundColor = [UIColor colorWithRed:0.105 green:0.792 blue:0.984 alpha:1];
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

- (void)configurarViewComBoleto:(BFOBoleto *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];

    [formatoData setDateStyle:NSDateFormatterShortStyle];
    [formatoData setDoesRelativeDateFormatting:YES];
    
    self.banco.text = boleto.banco;
    self.dataVencimento.text = [formatoData stringFromDate:boleto.dataVencimento];
    self.valor.text = boleto.valorExtenso;
    
    [self configurarContainerLinhaDigitavelComBoleto:boleto];
    [self calcularTransparenciaContainerLinhaDigitavel];
    
    [self configurarContainerCodigoBarrasComBoleto:boleto];
}

- (void)configurarContainerLinhaDigitavelComBoleto:(BFOBoleto *)boleto
{
    NSArray *sequenciasLinhaDigitavel = [boleto sequenciasLinhaDigitavel];
    BFOSequenciaLabel *textoSequencia;
    CGRect frameCampoSequencia;
    
    for (NSString *sequencia in sequenciasLinhaDigitavel) {
        
        if ([sequencia isEqual:[sequenciasLinhaDigitavel firstObject]]) {
            frameCampoSequencia =  CGRectMake(self.containerLinhaDigitavel.frame.size.width/2, 0, self.containerLinhaDigitavel.frame.size.width, self.containerLinhaDigitavel.frame.size.height);
        } else  {
            frameCampoSequencia =  CGRectMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemNumerosLinhaDigitavel, 0, self.containerLinhaDigitavel.frame.size.width, self.containerLinhaDigitavel.frame.size.height);
        }
        
        textoSequencia = [[BFOSequenciaLabel alloc] initWithFrame:frameCampoSequencia];
        
        textoSequencia.text = sequencia;
        [textoSequencia sizeToFit];
        
        if ([sequencia isEqual:[sequenciasLinhaDigitavel firstObject]]) {
            textoSequencia.center = CGPointMake(self.containerLinhaDigitavel.frame.size.width/2, textoSequencia.center.y);
        }
        
        [self.containerLinhaDigitavel addSubview:textoSequencia];
    }
    
    self.containerLinhaDigitavel.contentSize = CGSizeMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemLateralView, self.containerLinhaDigitavel.contentSize.height);
}

- (void)configurarContainerCodigoBarrasComBoleto:(BFOBoleto *)boleto
{
    BFOSequenciaLabel *textoSequencia = [[BFOSequenciaLabel alloc] initWithFrame:CGRectMake(20, 0, self.containerCodigoBarras.frame.size.width, self.containerCodigoBarras.frame.size.width)];
    
    textoSequencia.text = boleto.codigoBarras;
    [textoSequencia sizeToFit];
    
    [self.containerCodigoBarras addSubview:textoSequencia];
    self.containerCodigoBarras.contentSize = CGSizeMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemLateralView, self.containerCodigoBarras.contentSize.height);
}

- (void)calcularTransparenciaContainerLinhaDigitavel
{
    BFOSequenciaLabel *textoSequencia;
    CGFloat deslocamentoTextoSequencia, distanciaDoCentro, transparenciaTextoSequencia;
    
    for (UIView *view in [self.containerLinhaDigitavel subviews]) {
        if ([view isKindOfClass:[BFOSequenciaLabel class]]) {
            textoSequencia = (BFOSequenciaLabel *) view;
        } else {
            continue;
        }
        
        deslocamentoTextoSequencia = textoSequencia.center.x - self.containerLinhaDigitavel.contentOffset.x;
        distanciaDoCentro = abs(deslocamentoTextoSequencia - self.containerLinhaDigitavel.center.x);
        
        transparenciaTextoSequencia = distanciaDoCentro/self.containerLinhaDigitavel.center.x;
        
        if (transparenciaTextoSequencia >= 0.9f) {
            transparenciaTextoSequencia = 0.9f;
        }
        
        textoSequencia.alpha = 1.0f - transparenciaTextoSequencia;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.containerLinhaDigitavel]) {
        [self calcularTransparenciaContainerLinhaDigitavel];
    }
}

@end
