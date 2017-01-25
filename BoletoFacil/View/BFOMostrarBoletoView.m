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
#import "BFOLinhaDigitavelScrollView.h"

//Models
#import "BFOBoleto.h"

static const NSUInteger margemNumerosLinhaDigitavel = 15;
static const NSUInteger margemLateralView = 20;
static const NSUInteger alturaInicialEstadoServidorFundo = 30;

@interface BFOMostrarBoletoView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *estadoServidorFundo;
@property (weak, nonatomic) IBOutlet UILabel *estadoServidorMensagem;
@property (weak, nonatomic) IBOutlet UILabel *estadoServidorEndereco;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estadoServidorAltura;

@property (weak, nonatomic) IBOutlet UIView *corCategoria;
@property (weak, nonatomic) IBOutlet UILabel *categoria;
@property (weak, nonatomic) IBOutlet UILabel *banco;
@property (weak, nonatomic) IBOutlet UILabel *dataVencimento;
@property (weak, nonatomic) IBOutlet UILabel *valor;
@property (weak, nonatomic) IBOutlet BFOLinhaDigitavelScrollView *containerLinhaDigitavel;
@property (weak, nonatomic) IBOutlet UIScrollView *containerCodigoBarras;

@property (weak, nonatomic) NSString *linhaDigitavelCompleta;

@end

@implementation BFOMostrarBoletoView

#pragma mark - BFOMostrarBoletoView

- (void)alterarEstadoCriacaoServidor:(BFOEstadoCriacaoServidor)estado mensagem:(NSString *)mensagem
{
    UIColor *backgroundColor;
    
    switch (estado) {
        case BFOEstadoCriacaoServidorIniciando:
            backgroundColor = [UIColor colorWithRed:0.828 green:0.828 blue:0.828 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorSucesso:
            backgroundColor = [UIColor colorWithRed:0.298 green:0.85 blue:0.392 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorAviso:
            backgroundColor = [UIColor colorWithRed:0.105 green:0.792 blue:0.984 alpha:1];
            break;
            
        case BFOEstadoCriacaoServidorFalha:
            backgroundColor = [UIColor colorWithRed:1 green:0.176 blue:0.333 alpha:1];
            break;
    }
    
    if (estado == BFOEstadoCriacaoServidorSucesso) {
        if (self.estadoServidorEndereco.alpha) {
            return;
        }
        
        self.estadoServidorEndereco.text = mensagem;
        self.estadoServidorEndereco.alpha = 0;
        
        mensagem = @"Acesse o boleto a partir deste endereço:";
        
        self.estadoServidorAltura.constant = 1.7f * self.estadoServidorAltura.constant;
        [self.estadoServidorFundo setNeedsUpdateConstraints];
    } else {
        self.estadoServidorAltura.constant = alturaInicialEstadoServidorFundo;
        [self.estadoServidorFundo setNeedsUpdateConstraints];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.estadoServidorFundo.backgroundColor = backgroundColor;
        self.estadoServidorMensagem.text = mensagem;
        
        if (estado == BFOEstadoCriacaoServidorSucesso) {
            self.estadoServidorEndereco.alpha = 1.0f;
        } else {
            self.estadoServidorEndereco.alpha = 0;
        }
        
        [self layoutIfNeeded];
    }];
}

- (void)configurarViewComBoleto:(BFOBoleto *)boleto
{
    NSDateFormatter *formatoData = [NSDateFormatter new];

    [formatoData setDateStyle:NSDateFormatterShortStyle];
    [formatoData setDoesRelativeDateFormatting:YES];
    
    self.corCategoria.backgroundColor = boleto.corCategoria;
    self.categoria.text = boleto.categoria;
    self.banco.text = boleto.banco;
    
    if (boleto.dataVencimento) {
        self.dataVencimento.text = [formatoData stringFromDate:boleto.dataVencimento];
    } else {
        self.dataVencimento.text = @"-";
    }
    
    self.valor.text = boleto.valorExtenso;
    
    self.linhaDigitavelCompleta = [boleto linhaDigitavel];
    
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
            frameCampoSequencia =  CGRectMake(self.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height);
        } else  {
            frameCampoSequencia =  CGRectMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemNumerosLinhaDigitavel, 0, self.frame.size.width, self.containerLinhaDigitavel.frame.size.height);
        }
        
        textoSequencia = [[BFOSequenciaLabel alloc] initWithFrame:frameCampoSequencia];
        
        textoSequencia.text = sequencia;
        [textoSequencia sizeToFit];
        
        if ([sequencia isEqual:[sequenciasLinhaDigitavel firstObject]]) {
            textoSequencia.center = CGPointMake(self.frame.size.width/2, textoSequencia.center.y);
        }
        
        [self.containerLinhaDigitavel addSubview:textoSequencia];
    }
    
    if (textoSequencia.frame.size.width >= self.containerCodigoBarras.frame.size.width/2) {
        self.containerLinhaDigitavel.contentSize = CGSizeMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemLateralView, self.containerLinhaDigitavel.contentSize.height);
    } else {
        self.containerLinhaDigitavel.contentSize = CGSizeMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + self.frame.size.width/2, self.containerLinhaDigitavel.contentSize.height);
    }
    
    UILongPressGestureRecognizer *toqueCopiarTudo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(abrirMenuCopiarTudo:)];
    self.containerLinhaDigitavel.userInteractionEnabled = YES;
    [self.containerLinhaDigitavel addGestureRecognizer:toqueCopiarTudo];
}

- (void)abrirMenuCopiarTudo:(id)sender
{
    UILongPressGestureRecognizer *toqueCopiarTudo = (UILongPressGestureRecognizer *) sender;
    
    if (toqueCopiarTudo.state == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController;
        UIMenuItem *copiar;
        
        [self.containerLinhaDigitavel becomeFirstResponder];
        
        menuController = [UIMenuController sharedMenuController];
        copiar = [[UIMenuItem alloc] initWithTitle:@"Copiar linha" action:@selector(copiarTudo)];
        
        UIMenuItem *copiarAtual = menuController.menuItems.firstObject;
        
        if (copiarAtual && ![copiarAtual.title isEqualToString:copiar.title]) {
            [menuController setMenuVisible:NO animated:YES];
        }
        
        menuController.menuItems = @[copiar];
        
        if (self.containerLinhaDigitavel.frame.size.width > self.containerLinhaDigitavel.superview.frame.size.width) {
            [menuController setTargetRect:self.containerLinhaDigitavel.superview.bounds inView:self.containerLinhaDigitavel];
        } else {
            [menuController setTargetRect:self.containerLinhaDigitavel.bounds inView:self.containerLinhaDigitavel];
        }
        
        if ([menuController isMenuVisible]) {
            [menuController setMenuVisible:NO animated:YES];
        } else {
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (void)copiarTudo
{
    UIPasteboard *areaDeTransferencia = [UIPasteboard generalPasteboard];
    
    areaDeTransferencia.string = self.linhaDigitavelCompleta;
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
        distanciaDoCentro = fabs(deslocamentoTextoSequencia - self.center.x);
        
        transparenciaTextoSequencia = distanciaDoCentro/self.center.x;
        
        if (transparenciaTextoSequencia >= 0.9f) {
            transparenciaTextoSequencia = 0.9f;
        }
        
        textoSequencia.alpha = 1.0f - transparenciaTextoSequencia;
    }
}

- (void)configurarContainerCodigoBarrasComBoleto:(BFOBoleto *)boleto
{
    BFOSequenciaLabel *textoSequencia = [[BFOSequenciaLabel alloc] initWithFrame:CGRectMake(margemLateralView, 0, self.frame.size.width, self.frame.size.width)];
    
    textoSequencia.text = boleto.codigoBarras;
    [textoSequencia sizeToFit];
    
    [self.containerCodigoBarras addSubview:textoSequencia];
    self.containerCodigoBarras.contentSize = CGSizeMake(textoSequencia.frame.origin.x + textoSequencia.frame.size.width + margemLateralView, self.containerCodigoBarras.contentSize.height);
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
