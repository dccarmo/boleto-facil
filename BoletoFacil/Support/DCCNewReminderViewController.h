//
//  DCCNewReminderViewController.h
//  BoletoFacil
//
//  Created by Diogo do Carmo on 07/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFOBoleto;

@interface DCCNewReminderViewController : UITableViewController

- (instancetype)initWithBoleto:(BFOBoleto *)boleto;

@end
