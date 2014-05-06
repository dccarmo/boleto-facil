//
//  BFOSequenciaLinhaDigitavel.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 05/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOSequenciaLinhaDigitavel.h"

@implementation BFOSequenciaLinhaDigitavel

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
    
    menuController.menuItems = @[copiar];
    [menuController setTargetRect:CGRectMake(self.superview.center.x, self.center.y / 2, 2, 2) inView:self];
    [menuController setMenuVisible:YES animated:YES];
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
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
