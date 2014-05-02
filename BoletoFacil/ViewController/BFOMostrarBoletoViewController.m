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

//Pods
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>

@interface BFOMostrarBoletoViewController () <GCDWebServerDelegate>

@property (nonatomic) GCDWebServer *webServer;
@property (nonatomic) NSDictionary *codigoBarra;

@end

@implementation BFOMostrarBoletoViewController

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
    
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    self.webServer.delegate = self;
    
    // Add a handler to respond to GET requests on any URL
    [self.webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  
                                  return [GCDWebServerDataResponse responseWithHTML:[NSString stringWithFormat:@"<html><body><p>Seu código de barras é: %@</p></body></html>", codigo]];
                                  
                              }];
    
    // Start server on port 8080
    [self.webServer startWithPort:8080 bonjourName:nil];
}

#pragma mark - GCDWebServerDelegate

- (void)webServerDidStart:(GCDWebServer *)server
{
    BFOMostrarBoletoView *view = (BFOMostrarBoletoView *) self.view;
    
    view.urlServidor.text = [server.serverURL absoluteString];
}

@end
