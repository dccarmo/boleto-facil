//
//  BFOEscanearBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

@import AVFoundation;

#import "BFOEscanearBoletoViewController.h"

//Views
#import "BFOEscanearBoletoView.h"

//Model
#import "BFOGerenciadorCodigoBarra.h"

//Pods
#import <ZBarSDK.h>

@interface BFOEscanearBoletoViewController () <ZBarReaderViewDelegate>

@property (nonatomic) BFOGerenciadorCodigoBarra *barCodes;

@end

@implementation BFOEscanearBoletoViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOEscanearBoletoView" bundle:nil];
    if (self) {
         self.barCodes = [BFOGerenciadorCodigoBarra sharedGerenciadorCodigoBarra];
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

- (IBAction)fecharAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        
        [self.barCodes adicionarCodigo:symbol.data];
    }
}

@end
