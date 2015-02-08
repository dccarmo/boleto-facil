//
//  BFOSequenciaLinhaDigitavel.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOSequenciaLabel.h"

@implementation BFOSequenciaLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *toqueCopiar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(abrirMenu)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:toqueCopiar];
        
        [self definirEstiloTexto];
    }
    return self;
}

#pragma mark - BFOSequenciaLinhaDigitavel

- (void)abrirMenu
{
    UIMenuController *menuController;
    UIMenuItem *copiar;
    
    [self becomeFirstResponder];
    
    menuController = [UIMenuController sharedMenuController];
    copiar = [[UIMenuItem alloc] initWithTitle:@"Copiar" action:@selector(copiarSequencia)];
    
    UIMenuItem *copiarAtual = menuController.menuItems.firstObject;
    
    if (copiarAtual && ![copiarAtual.title isEqualToString:copiar.title]) {
        [menuController setMenuVisible:NO animated:YES];
    }
    
    menuController.menuItems = @[copiar];
    
    if (self.frame.size.width > self.superview.frame.size.width) {
        [menuController setTargetRect:self.superview.bounds inView:self];
    } else {
        [menuController setTargetRect:self.bounds inView:self];
    }
    
    if ([menuController isMenuVisible]) {
        [menuController setMenuVisible:NO animated:YES];
    } else {
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)copiarSequencia
{
    UIPasteboard *areaDeTransferencia = [UIPasteboard generalPasteboard];
    
    areaDeTransferencia.string = self.text;
}

- (void)definirEstiloTexto
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35.0f];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor darkGrayColor];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
