//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
//
#import "jjkInfoViewController.h"

#define checkMarkXOffset 50
#define checkMarkYOffset 5

@interface jjkInfoViewController ()

@property (retain, nonatomic) IBOutlet UIView *themeView;
- (IBAction)dismissPressed:(id)sender;
- (IBAction)themeButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *checkButtonImage;
@property (retain, nonatomic) IBOutlet UIButton *classicButton;

@end

CGPoint buttonOrigin;

@implementation jjkInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    self.checkButtonImage.frame = CGRectMake(buttonOrigin.x - checkMarkXOffset, buttonOrigin.y + checkMarkYOffset, self.checkButtonImage.frame.size.width, self.checkButtonImage.frame.size.height);
    
    [self.themeView addSubview:self.checkButtonImage];

    
    
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
    UIButton *buttonSelected = sender;
    buttonOrigin = buttonSelected.frame.origin;
    
    self.checkButtonImage.frame = CGRectMake(buttonOrigin.x - checkMarkXOffset, buttonOrigin.y + checkMarkYOffset, self.checkButtonImage.frame.size.width, self.checkButtonImage.frame.size.height);
    
    [self.themeView addSubview:self.checkButtonImage];
    
    
    NSInteger tag = [sender tag];    
    [self.delegate changeTheme:tag];
}
- (void)dealloc {
    [_checkButtonImage release];
    [_themeView release];
    [_classicButton release];
    [super dealloc];
}
@end
