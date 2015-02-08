//
//  BFOLembretesViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 17/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOListaLembretesViewController.h"

//Model
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

@interface BFOListaLembretesViewController ()

@property (nonatomic) NSArray *lembretes;

@end

@implementation BFOListaLembretesViewController

//- (instancetype)init
//{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (self) {
//        self.navigationItem.title = @"Lembretes agendados";
//    }
//    return self;
//}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"Lembretes";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self carregarLembretes];
}

#pragma mark - BFOListaLembretesViewController

- (void)carregarLembretes
{
    self.lembretes = [[UIApplication sharedApplication].scheduledLocalNotifications sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fireDate" ascending:YES]]];
    
    if ([self.lembretes count] == 0) {
        self.tableView.backgroundView = [[[NSBundle mainBundle] loadNibNamed:@"BFOListaLembretesVaziaView" owner:self options:nil] firstObject];
    } else {
        self.tableView.backgroundView = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lembretes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDateFormatter *formatoData = [NSDateFormatter new];
    UILocalNotification *notificacao = self.lembretes[indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    [formatoData setDateFormat:@"EEE, dd/MM/yy h:mm"];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    cell.textLabel.text = notificacao.alertBody;
    
    cell.detailTextLabel.text = [formatoData stringFromDate:notificacao.fireDate];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification *notificacao;
    BFOBoleto *boleto;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        notificacao = self.lembretes[indexPath.row];
        
        boleto = [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] boletoComCodigoBarras:notificacao.userInfo[@"codigoBarras"]];
        [boleto cancelarLembrete:notificacao];
        
        [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
        
        [self carregarLembretes];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

@end
