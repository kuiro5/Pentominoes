//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 4
// Date: September 26, 2013
//
#import "jjkInfoViewController.h"

#define checkMarkXOffset 50
#define checkMarkYOffset 5

@interface jjkInfoViewController ()

@property (retain, nonatomic) IBOutlet UIView *themeView;
- (IBAction)dismissPressed:(id)sender;
- (IBAction)themeButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *greenButton;
@property (retain, nonatomic) IBOutlet UIButton *darkButton;
@property (retain, nonatomic) IBOutlet UIImageView *checkButtonImage;
@property (retain, nonatomic) IBOutlet UIButton *classicButton;
@property CGPoint buttonOrigin;
@property (retain, nonatomic) UIColor *themeDisplayed;

@end

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
    
	self.themeDisplayed = [self.delegate currentTheme];
    
    if(self.themeDisplayed == [UIColor scrollViewTexturedBackgroundColor])
    {
        self.buttonOrigin = self.classicButton.frame.origin;
    }
    else if (self.themeDisplayed == [UIColor greenColor])
    {
        self.buttonOrigin = self.greenButton.frame.origin;
    }
    else if(self.themeDisplayed == [UIColor blueColor])
    {
        self.buttonOrigin = self.darkButton.frame.origin;
    }
    
    self.checkButtonImage.frame = CGRectMake(self.buttonOrigin.x - checkMarkXOffset, self.buttonOrigin.y + checkMarkYOffset, self.checkButtonImage.frame.size.width, self.checkButtonImage.frame.size.height);
    
    [self.themeView addSubview:self.checkButtonImage];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
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
    
    UIButton *buttonSelected = sender;
    self.buttonOrigin = buttonSelected.frame.origin;
    
    self.checkButtonImage.frame = CGRectMake(self.buttonOrigin.x - checkMarkXOffset, self.buttonOrigin.y + checkMarkYOffset, self.checkButtonImage.frame.size.width, self.checkButtonImage.frame.size.height);
    
    [self.themeView addSubview:self.checkButtonImage];
     
    [self.delegate changeTheme:tag];
}
- (void)dealloc {
    [_checkButtonImage release];
    [_themeView release];
    [_classicButton release];
    [_greenButton release];
    [_darkButton release];
    [_themeDisplayed release];
    [_delegate release];
    [super dealloc];
}
@end
