//
//  jjkInfoViewController.m
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/19/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkInfoViewController.h"

@interface jjkInfoViewController ()

- (IBAction)dismissPressed:(id)sender;

@end

@implementation jjkInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPressed:(id)sender
{
    [self.delegate dismissMe];
}
@end
