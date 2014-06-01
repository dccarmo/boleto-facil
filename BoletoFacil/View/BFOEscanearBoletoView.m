//
//  BFOEscanearBoletoView.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOEscanearBoletoView.h"

//Pods
#import <ZBarSDK.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface BFOEscanearBoletoView()

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *botaoFlash;
@property (weak, nonatomic) IBOutlet UIButton *botaoFechar;
@property (weak, nonatomic) IBOutlet UIView *linhaEsquerda;
@property (weak, nonatomic) IBOutlet UIView *linhaDireita;

@property (nonatomic) UIDynamicAnimator *animador;

@end

@implementation BFOEscanearBoletoView

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UINibLoading

- (void)awakeFromNib
{
    self.botaoFechar.hidden = YES;
    self.botaoFlash.hidden = YES;
    
    self.botaoFechar.center = CGPointMake(self.botaoFechar.center.x, self.frame.size.height - self.botaoFechar.frame.size.height/2 - 20); //para se adaptar a tela menor
    
    self.linhaEsquerda.hidden = YES;
    self.linhaDireita.hidden = YES;
    
    [self rotacionarBotoes];
//    [self adicionarEfeitoMovimentoBotoes];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotacionarBotoes) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - BFOEscanearBoletoView

- (void)setupCameraPreviewView:(ZBarReaderView *)readerView
{
    readerView.frame = self.cameraPreviewView.frame;
    [self.cameraPreviewView addSubview:readerView];
}

- (void)alterarBotaoFecharParaBotaoSucesso
{
    self.botaoFechar.userInteractionEnabled = NO;
    self.botaoFechar.selected = YES;
}

- (void)mostrarBotoes
{
    UISnapBehavior *snapBehavior;
    
    self.animador = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    //Botao Fechar
    self.botaoFechar.center = CGPointMake(self.botaoFechar.center.x, self.botaoFechar.center.y + self.botaoFechar.frame.size.height + 20);
    self.botaoFechar.hidden = NO;
    
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.botaoFechar snapToPoint:CGPointMake(self.botaoFechar.center.x,
                                                                                                 self.botaoFechar.center.y - (self.botaoFechar.frame.size.height + 20))];
    [self.animador addBehavior:snapBehavior];
    
    //Botao Flash
    self.botaoFlash.center = CGPointMake(self.botaoFlash.center.x, self.botaoFlash.center.y - (self.botaoFlash.frame.size.height + 20));
    self.botaoFlash.hidden = NO;
    
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.botaoFlash snapToPoint:CGPointMake(self.botaoFlash.center.x,
                                                                                                 self.botaoFlash.center.y + (self.botaoFlash.frame.size.height + 20))];

    [self.animador addBehavior:snapBehavior];
    
    [self mostrarLinhas];
    
    [self performSelector:@selector(rotacionarBotoes) withObject:nil afterDelay:1.2]; //Hack muito feio
}

- (void)rotacionarBotoes
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSUInteger degrees;
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            degrees = 0;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            degrees = 180;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            degrees = 90;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            degrees = 270;
            break;
            
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            return;
            break;
    }
    
    [UIView beginAnimations:@"rotacionarBotaoFechar" context:nil];
    [UIView setAnimationDuration:0.5];
        self.botaoFechar.transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
        self.botaoFlash.transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    [UIView commitAnimations];
}

- (void)adicionarEfeitoMovimentoBotoes
{
    UIInterpolatingMotionEffect *efeitoX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *efeitoY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    efeitoX.maximumRelativeValue = @10;
    efeitoX.minimumRelativeValue = @(-10);
    
    efeitoY.maximumRelativeValue = @10;
    efeitoY.minimumRelativeValue = @(-10);
    
    [self.botaoFechar addMotionEffect:efeitoX];
    [self.botaoFechar addMotionEffect:efeitoY];
    
    [self.botaoFlash addMotionEffect:efeitoX];
    [self.botaoFlash addMotionEffect:efeitoY];
}

- (void)mostrarLinhas
{
    self.linhaEsquerda.alpha = 0;
    self.linhaDireita.alpha = 0;
    
    self.linhaEsquerda.hidden = NO;
    self.linhaDireita.hidden = NO;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.linhaEsquerda.alpha = 0.5f;
        self.linhaDireita.alpha = 0.5f;
    }];
}

@end
