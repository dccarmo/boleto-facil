//
//  BFOConfiguracoesViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 15/05/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOConfiguracoesViewController.h"

//App Delegate
#import "BFOAppDelegate.h"

typedef NS_ENUM(NSUInteger, BFOConfiguracoesViewControllerSecao)
{
    BFOConfiguracoesViewControllerSecaoTelaPrincipal,
    BFOConfiguracoesViewControllerSecaoLembretes
};

@interface BFOConfiguracoesViewController ()

@end

@implementation BFOConfiguracoesViewController

- (instancetype)init
{
    UIStoryboard* configuracoesStoryboard = [UIStoryboard storyboardWithName:@"BFOConfiguracoesStoryboard" bundle:nil];
    
    self = [configuracoesStoryboard instantiateInitialViewController];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - BFOConfiguracoesViewController

- (IBAction)fechar:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == BFOConfiguracoesViewControllerSecaoTelaPrincipal) {
        if (indexPath.row == [defaults integerForKey:BFOOrdenacaoTelaPrincipalKey]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == BFOConfiguracoesViewControllerSecaoTelaPrincipal) {
        [defaults setObject:[NSNumber numberWithInteger:indexPath.row] forKey:BFOOrdenacaoTelaPrincipalKey];
        
        [self.tableView reloadData];
    }
}

@end
