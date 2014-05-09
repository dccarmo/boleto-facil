//
//  BFOAdicionarLembreteActivity.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 07/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOAdicionarLembreteActivity.h"

//Model
#import "BFOBoleto.h"

//Support
#import "DCCNewReminderViewController.h"

@interface BFOAdicionarLembreteActivity ()

@property (nonatomic) BFOBoleto *boleto;

@end

@implementation BFOAdicionarLembreteActivity

- (instancetype)initWithBoleto:(BFOBoleto *)boleto
{
    self = [super init];
    if (self) {
        self.boleto = boleto;
    }
    return self;
}

#pragma mark - UIActivity

- (NSString *)activityType
{
    return @"UIActivityTypeAdicionarLembrete";
}

- (NSString *)activityTitle
{
    return @"Adicionar Lembrete";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"botao_activity_lembrete"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    
}

- (UIViewController *)activityViewController
{
    return [[UINavigationController alloc] initWithRootViewController:[[DCCNewReminderViewController alloc] initWithActivity:self boleto:self.boleto]];
}

@end
