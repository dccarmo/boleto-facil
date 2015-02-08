//
//  BFOBaseTableViewController.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 2/7/15.
//  Copyright (c) 2015 Diogo do Carmo. All rights reserved.
//

#import "BFOBaseTableViewController.h"

//Pods
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface BFOBaseTableViewController ()

@end

@implementation BFOBaseTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:self.title];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
