//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
//
#import "jjkInfoViewController.h"

@interface jjkInfoViewController ()

- (IBAction)dismissPressed:(id)sender;
- (IBAction)themeButtonPressed:(id)sender;

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
	// Do any additional setup after loading the view
    
    
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

- (IBAction)themeButtonPressed:(id)sender
{
    NSInteger tag = [sender tag];
    
    
    [self.delegate changeTheme:tag];
}
@end
