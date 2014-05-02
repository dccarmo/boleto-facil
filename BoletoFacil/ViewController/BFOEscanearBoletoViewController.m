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
#import "BFOGerenciadorCodigoBarra.h"

//Pods
#import <ZBarSDK.h>

@interface BFOEscanearBoletoViewController () <ZBarReaderViewDelegate>

@property (nonatomic) BFOGerenciadorCodigoBarra *gerenciadorCodigoBarra;

@end

@implementation BFOEscanearBoletoViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOEscanearBoletoView" bundle:nil];
    if (self) {
         self.gerenciadorCodigoBarra = [BFOGerenciadorCodigoBarra sharedGerenciadorCodigoBarra];
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
    ZBarReaderView *readerView = [[ZBarReaderView alloc] initWithImageScanner:[ZBarImageScanner new]];
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
    
    [view setupCameraPreviewView:readerView];
    
    readerView.readerDelegate = self;
    readerView.zoom = 1.0;
    [readerView.scanner setSymbology:ZBAR_EAN5 config:ZBAR_CFG_ENABLE to:0];
    [readerView start];
    
}

- (IBAction)fecharAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = (BFONavegacaoPrincipalViewController *) self.presentingViewController;
    
    for (ZBarSymbol *symbol in symbols) {
        [self.gerenciadorCodigoBarra adicionarCodigo:symbol.data];
        
        [navegacaoPrincipal pushViewController:[[BFOMostrarBoletoViewController alloc] initWithCodigoBarra:self.gerenciadorCodigoBarra.ultimoCodigo] animated:NO];
        
        [self fecharAction];
    }
}

@end
