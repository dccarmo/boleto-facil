//
//  BFOMostrarBoletoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOMostrarBoletoViewController.h"

//Views
#import "BFOMostrarBoletoView.h"

//Support
#import "DCCBoletoBancarioFormatter.h"

//Pods
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>

@interface BFOMostrarBoletoViewController () <GCDWebServerDelegate>

@property (nonatomic) GCDWebServer *webServer;
@property (nonatomic) NSDictionary *codigoBarra;

@end

@implementation BFOMostrarBoletoViewController

- (void)dealloc
{
    [self.webServer stop];
}

- (instancetype)initWithCodigoBarra:(NSDictionary *)codigoBarra
{
    self = [super initWithNibName:@"BFOMostrarBoletoView" bundle:nil];
    if (self) {
        self.codigoBarra = codigoBarra;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self inicializarWebService];
}

- (void)inicializarWebService
{
    NSString *codigo = self.codigoBarra[@"codigo"];
    DCCBoletoBancarioFormatter *formatoLinhaDigitavel = [DCCBoletoBancarioFormatter new];
    
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    self.webServer.delegate = self;
    
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  
                                  return [GCDWebServerDataResponse responseWithHTML:[NSString stringWithFormat:@"<html><body><p>Seu código de barras é: %@</p></body></html>", [formatoLinhaDigitavel stringForObjectValue:codigo]]];
                                  }];
    
    [self.webServer start];
}

#pragma mark - GCDWebServerDelegate

- (void)webServerDidStart:(GCDWebServer *)server
{
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    
    view.urlServidor.text = [server.serverURL absoluteString];
}

@end
