//
//  BFOEscanearBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

@import AVFoundation;

#import "BFOEscanearBoletoViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

//View Controllers
#import "BFOMostrarBoletoViewController.h"
#import "BFONavegacaoPrincipalViewController.h"

//Views
#import "BFOEscanearBoletoView.h"

//Models
#import "BFOBoleto.h"

//Support
#import "DCCBoletoFormatter.h"
#import "BFOArmazenamentoBoleto.h"

//Pods
#import <ZBarSDK.h>

@interface BFOEscanearBoletoViewController () <ZBarReaderViewDelegate>

@property (nonatomic) ZBarReaderView *leitorView;

@end

@implementation BFOEscanearBoletoViewController

- (instancetype)init
{
    self = [super initWithNibName:@"BFOEscanearBoletoView" bundle:nil];
    if (self) {

    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self capturarCodigoBarra];
    
    self.title = @"Escanear boleto";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:BFONenhumBoletoLidoKey]) {
        NSString *title = @"Ajuda";
        NSString *message = @"Alinhe o código de barras do boleto entre as duas barras e o aplicativo irá lê-lo automaticamente.";
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Entendi" style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Entendi", nil];
            [alertView show];
        }
    }
    
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
   
    [view mostrarBotoes];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - BFOEscanearBoletoViewController

- (void)capturarCodigoBarra
{
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
    
    self.leitorView = [[ZBarReaderView alloc] initWithImageScanner:[ZBarImageScanner new]];
    [view setupCameraPreviewView:self.leitorView];
    
    self.leitorView.readerDelegate = self;
    self.leitorView.zoom = 1.0;
    [self.leitorView.scanner setSymbology:ZBAR_EAN5 config:ZBAR_CFG_ENABLE to:0];
    self.leitorView.torchMode = AVCaptureTorchModeOff;
    self.leitorView.tracksSymbols = NO;
    
    [self.leitorView start];
}

- (IBAction)fecharAction:(id)sender
{
    self.leitorView.torchMode = AVCaptureTorchModeOff;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)alterarFlashAction:(id)sender
{
    UIButton *botaoFlash = (UIButton *) sender;
    
    botaoFlash.selected = !botaoFlash.selected;
    
    if (botaoFlash.selected) {
        self.leitorView.torchMode = AVCaptureTorchModeOn;
    } else {
        self.leitorView.torchMode = AVCaptureTorchModeOff;
    }
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    BFONavegacaoPrincipalViewController *navegacaoPrincipal = (BFONavegacaoPrincipalViewController *) self.presentingViewController;
    BFOEscanearBoletoView *view = (BFOEscanearBoletoView *) self.view;
    NSString *codigoBarras;
    DCCBoletoFormatter *formatoBoleto = [DCCBoletoFormatter new];
    
    for (ZBarSymbol *symbol in symbols) {
        codigoBarras = symbol.data;
        codigoBarras = [[codigoBarras componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        if (![formatoBoleto linhaDigitavelDoCodigoBarra:codigoBarras]) {
            //Alterar o formato do botao para X vermelho, indicando erro
            continue;
        }
        
        self.boleto = [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] adicionarBoletoComCodigoBarras:codigoBarras];
        
        [self.leitorView stop];
        
        [view alterarBotaoFecharParaBotaoSucesso];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@NO forKey:BFONenhumBoletoLidoKey];
        [userDefaults synchronize];
        
        [[navegacaoPrincipal topViewController] performSegueWithIdentifier:@"mostrarBoletoSegue" sender:self];
        
        [self performSelector:@selector(fecharAction:) withObject:nil afterDelay:2.0f];
        
        break;
    }
}

@end
