//
//  BFOMostrarBoletoViewController.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDWebServer;

@interface BFOMostrarBoletoViewController : UIViewController

/**
 *  Designated initializer
 */
- (instancetype)initWithCodigoBarra:(NSDictionary *)boleto;

@end
