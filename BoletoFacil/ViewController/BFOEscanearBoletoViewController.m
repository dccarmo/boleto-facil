//
//  BFOEscanearBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

@import AVFoundation;

#import "BFOEscanearBoletoViewController.h"

//View Controllers
#import "BFOMostrarBoletoViewController.h"
#import "BFONavegacaoPrincipalViewController.h"

//Views
#import "BFOEscanearBoletoView.h"

//Models
#import "BFOGerenciadorBoleto.h"

//Support
#import "DCCBoletoBancarioFormatter.h"

//Pods
#import <ZBarSDK.h>

@interface BFOEscanearBoletoViewController () <ZBarReaderViewDelegate>

@property (nonatomic) BFOGerenciadorBoleto *gerenciadorBoleto;
@property (nonatomic) ZBarReaderView *leitorView;

@end

@implementation BFOEscanearBoletoViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOEscanearBoletoView" bundle:nil];
    if (self) {
         self.gerenciadorBoleto = [BFOGerenciadorBoleto sharedGerenciadorBoleto];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self capturarCodigoBarra];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)capturarCodigoBarra
{
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
    
    self.leitorView = [[ZBarReaderView alloc] initWithImageScanner:[ZBarImageScanner new]];
    [view setupCameraPreviewView:self.leitorView];
    
    self.leitorView.readerDelegate = self;
    self.leitorView.zoom = 1.0;
    [self.leitorView.scanner setSymbology:ZBAR_EAN5 config:ZBAR_CFG_ENABLE to:0];
    [self.leitorView start];
    
}

- (IBAction)fecharAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = (BFONavegacaoPrincipalViewController *) self.presentingViewController;
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
    NSString *codigo;
    DCCBoletoBancarioFormatter *formatoBoleto = [DCCBoletoBancarioFormatter new];
    
    for (ZBarSymbol *symbol in symbols) {
        codigo = symbol.data;
        codigo = [[codigo componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        if (![formatoBoleto linhaDigitavelDoCodigoBarra:codigo]) {
            //Alterar o formato do botao para X vermelho, indicando erro
            continue;
        }
        
        [self.gerenciadorBoleto adicionarCodigoBarras:symbol.data];
        [self.leitorView stop];
        
        [navegacaoPrincipal pushViewController:[[BFOMostrarBoletoViewController alloc] initWithCodigoBarra:self.gerenciadorBoleto.ultimoBoleto] animated:NO];
        
        [view alterarBotaoFecharParaBotaoSucesso];
        
        [self performSelector:@selector(fecharAction) withObject:nil afterDelay:2.0f];
        
        break;
    }
}

@end
