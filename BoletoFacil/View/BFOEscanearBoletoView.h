//
//  BFOEscanearBoletoView.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBarReaderView;

@interface BFOEscanearBoletoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *botaoFechar;

- (void)setupCameraPreviewView:(ZBarReaderView *)readerView;
- (void)alterarBotaoFecharParaBotaoSucesso;

@end
