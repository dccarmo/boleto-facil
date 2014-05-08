//
//  DCCNewReminderViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 07/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "DCCNewReminderViewController.h"

//Views
#import "BFOAdicionarLembreteActivity.h"

//Models
#import "BFOBoleto.h"

//Support
#import "BFOArmazenamentoBoleto.h"

typedef NS_ENUM(NSUInteger, DCCNewReminderSection)
{
    DCCNewReminderSectionTitle,
    DCCNewReminderSectionAlarm
};

typedef NS_ENUM(NSUInteger, DCCNewReminderRow)
{
    DCCNewReminderRowTitle = 0,
    DCCNewReminderRowAlarmInfo = 0,
    DCCNewReminderRowAlarmePicker = 1
};

@interface DCCNewReminderViewController ()

@property (nonatomic, weak) BFOAdicionarLembreteActivity *activity;
@property (nonatomic) BFOBoleto *boleto;

@property (nonatomic) UITextField *titleField;
@property (nonatomic) UILabel *dateInfo;
@property (nonatomic) UIDatePicker *datePicker;

@end

@implementation DCCNewReminderViewController

- (instancetype)initWithActivity:(BFOAdicionarLembreteActivity *)activity boleto:(BFOBoleto *)boleto
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UIBarButtonItem *salvar = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(salvarLembrete)];
        UIBarButtonItem *cancelar = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStyleDone target:self action:@selector(fechar)];
        UIBarButtonItem *remover = [[UIBarButtonItem alloc] initWithTitle:@"Remover" style:UIBarButtonItemStyleDone target:self action:@selector(removerLembrete)];
        
        _activity = activity;
        _boleto = boleto;
        
        self.navigationItem.title = @"Novo Lembrete";
        self.navigationItem.rightBarButtonItem = salvar;
        
        if (_boleto.dataLembrete) {
            self.navigationItem.leftBarButtonItem = remover;
        } else {
            self.navigationItem.leftBarButtonItem = cancelar;
        }
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateDateInfo];
}

#pragma mark - DCCNewReminderViewController

- (void)fechar
{
    [self.activity activityDidFinish:YES];
}

- (void)salvarLembrete
{
    UILocalNotification *notification = [UILocalNotification new];
    
    notification.alertBody = self.titleField.text;
    notification.fireDate = self.datePicker.date;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    
    if (self.boleto.dataLembrete) {
        [self removerNotificacao];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    self.boleto.tituloLembrete = self.titleField.text;
    self.boleto.dataLembrete = self.datePicker.date;
    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
    
    [self fechar];
}

- (void)removerLembrete
{
    [self removerNotificacao];
    
    self.boleto.tituloLembrete = nil;
    self.boleto.dataLembrete = nil;
    [[BFOArmazenamentoBoleto sharedArmazenamentoBoleto] salvar];
    
    [self fechar];
}

- (void)removerNotificacao
{
    for (UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications) {
        if ([notification.fireDate isEqualToDate:self.boleto.dataLembrete]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}


- (UITextField *)titleField
{
    if (!_titleField) {
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(self.tableView.separatorInset.left, 0, self.tableView.frame.size.width, 44.0f)];
        _titleField.placeholder = @"";
        
        if (self.boleto.tituloLembrete) {
            _titleField.text = self.boleto.tituloLembrete;
        } else {
            _titleField.text = [NSString stringWithFormat:@"Pagar boleto do %@", self.boleto.banco];
        }
    }
    
    return _titleField;
}

- (UILabel *)dateInfo
{
    if (!_dateInfo) {
        _dateInfo = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.center.x - self.tableView.separatorInset.left * 2, 0, self.tableView.center.x + self.tableView.separatorInset.left, 44.0f)];
        _dateInfo.textColor = [UIColor lightGrayColor];
        _dateInfo.textAlignment = NSTextAlignmentRight;
    }
    
    return _dateInfo;
}

- (UIDatePicker *)datePicker
{
    NSDateComponents *dateComponents;
    
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
        _datePicker.minimumDate = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        if (self.boleto.dataLembrete) {
            _datePicker.date = self.boleto.dataLembrete;
        } else {
            dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.boleto.dataVencimento];
            [dateComponents setHour:8];
            [dateComponents setMinute:0];
            
            _datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        }
        
        [_datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    }
    
    return _datePicker;
}

- (void)datePickerChanged
{
    [self updateDateInfo];
}

- (void)updateDateInfo
{
    NSDateFormatter *dateFormat;
    
    dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"EEE, dd/MM/yy h:mm"];
    self.dateInfo.text = [dateFormat stringFromDate:self.datePicker.date];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case DCCNewReminderSectionTitle:
            return 1;
            break;
            
        case DCCNewReminderSectionAlarm:
            return 2;
            break;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case DCCNewReminderSectionTitle:
            [cell addSubview:self.titleField];
            break;
            
        case DCCNewReminderSectionAlarm:
            switch (indexPath.row) {
                case DCCNewReminderRowAlarmInfo:
                    cell.textLabel.text = @"Alarme";
                    [cell addSubview:self.dateInfo];
                    break;
                    
                case DCCNewReminderRowAlarmePicker:
                    [cell addSubview:self.datePicker];
                    break;
            }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DCCNewReminderSectionAlarm && indexPath.row == DCCNewReminderRowAlarmePicker) {
        return self.datePicker.frame.size.height;
    }
    
    return 44.0f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
