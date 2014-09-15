//
//  BFODataVencimentoViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 25/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOInformarDataVencimentoViewController.h"

//Models
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

@interface BFOInformarDataVencimentoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *data;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BFOInformarDataVencimentoViewController

//- (instancetype)initWithBoleto:(BFOBoleto *)boleto
//{
//    UIStoryboard* dataVencimentoStoryboard = [UIStoryboard storyboardWithName:@"BFOInformarDataVencimento" bundle:nil];
//    
//    self = [dataVencimentoStoryboard instantiateInitialViewController];
//    if (self) {
//        self.boleto = boleto;
//    }
//    return self;
//}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateComponents *componentesData = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    [componentesData setYear:[componentesData year] + 1];
    self.datePicker.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:componentesData];
    
    [self dataMudouAction:nil];
}

#pragma mark - BFODataVencimentoViewController

- (IBAction)fechar:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)salvar:(id)sender
{
    [self.boleto informarDataVencimento:self.datePicker.date];
    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dataMudouAction:(id)sender
{
    NSDateFormatter *formatoData = [NSDateFormatter new];
    
    [formatoData setDateStyle:NSDateFormatterShortStyle];
    
    self.data.text = [formatoData stringFromDate:self.datePicker.date];
}

@end
