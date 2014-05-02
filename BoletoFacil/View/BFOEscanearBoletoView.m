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

@interface BFOEscanearBoletoView()

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *botaoFechar;

@end

@implementation BFOEscanearBoletoView

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

@end
