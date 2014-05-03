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
@property (weak, nonatomic) IBOutlet UIButton *botaoFechar;

@end

@implementation BFOEscanearBoletoView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotacionarBotaoFechar) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
        [self rotacionarBotaoFechar];
    }
    return self;
}

- (void)setupCameraPreviewView:(ZBarReaderView *)readerView
{
    readerView.frame = self.cameraPreviewView.frame;
    [self.cameraPreviewView addSubview:readerView];
}

#pragma mark - botaoFechar

- (void)alterarBotaoFecharParaBotaoSucesso
{
    self.botaoFechar.userInteractionEnabled = NO;
    self.botaoFechar.selected = YES;
}

- (void)rotacionarBotaoFechar
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
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.5];
        self.botaoFechar.transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    [UIView commitAnimations];
}

@end
