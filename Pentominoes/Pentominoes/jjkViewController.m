//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 2
// Date: September 13, 2013
//

#import "jjkViewController.h"
#import "jjkInfoViewController.h"
#import "Model.h"
#define yOffset 110
#define xOffset 15
#define squareDimension 30
#define screenBuffer 10

@interface jjkViewController () <InfoDelegate>
- (IBAction)solveButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temporaryImageView;

@property NSInteger currentBoardSelected;
@property (nonatomic,strong) Model *model;

-(IBAction)unwindSegue:(UIStoryboardSegue*)segue;
@end

BOOL solved = NO;

@implementation jjkViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [[Model alloc] init];
    }
    return self;
}

-(void)dismissMe {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)displayPuzzlePieces
{
    
    
    CGPoint startingPoint = self.boardImageView.frame.origin;               // find boards origins
    startingPoint.y += self.boardImageView.frame.size.height + yOffset/2;
    startingPoint.x = (self.boardImageView.frame.origin.x)/3;
    
    CGPoint rightEdge;
    rightEdge.x = self.boardImageView.frame.origin.x + self.boardImageView.frame.size.width;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = self.view.bounds.size.width;        // get screen width to use for bounds
    
    NSMutableDictionary *temporaryDictionary = [self.model getPuzzlePieceDictionary];
    
    for(id key in temporaryDictionary)
    {
        self.temporaryImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
        
        if(currentPoint.x + self.temporaryImageView.image.size.width/2 >= screenWidth - screenBuffer)        // line break
        {
            currentPoint.x = startingPoint.x;
            currentPoint.y += yOffset;
            
            self.temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, self.temporaryImageView.frame.size.width, self.temporaryImageView.frame.size.height);
            
            currentPoint.x += self.temporaryImageView.image.size.width/2 + xOffset;
            
            
        }
        else                                                                    // add piece to current row 
        {
            self.temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, self.temporaryImageView.frame.size.width, self.temporaryImageView.frame.size.height);
            currentPoint.x += self.temporaryImageView.image.size.width/2 + xOffset;
            
            
        }
        
        self.temporaryImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
         UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];

        doubleTap.numberOfTapsRequired = 2;

        
        [self.temporaryImageView addGestureRecognizer:singleTap];
        [self.temporaryImageView addGestureRecognizer:doubleTap];
        [self.temporaryImageView addGestureRecognizer:panGesture];
        
        [self.view addSubview:self.temporaryImageView];
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self.model initializePuzzlePieces];
    [self.model initializeSolutions];
    
    [UIView animateWithDuration:1 animations:^{
    [self displayPuzzlePieces];
    }];
    
    self.resetButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)boardButtonPressed:(id)sender
{
    [self resetButtonPressed:nil];
    
    
    solved = NO;
    
    NSInteger board = [sender tag];
    
    NSString *boardImageSelected = [self.model getBoardImage:board];
    
    
    
   // [NSString stringWithFormat:@"Board%d.png", [sender tag]];        // tag corresponds to specific Board, i.e. Board 1 has a tag of 1
    
    self.boardImageView.image = [UIImage imageNamed:boardImageSelected];
    
    self.currentBoardSelected = [sender tag];
    
    self.resetButton.enabled = NO;
    
    
}

- (IBAction)solveButtonPressed:(id)sender
{
    solved = YES;
    NSArray *solutionsArray = [self.model getSolutions];
    NSDictionary *boardDictionary;
    
    NSMutableDictionary *temporaryDictionary = [self.model getPuzzlePieceDictionary];
    
    
    if(self.currentBoardSelected != 0)
    {
        self.resetButton.enabled = YES;
    }
    else
    {
        self.resetButton.enabled = NO;
    }
    
    
    if(self.currentBoardSelected == 0)
    {
        return;
    }
    
    boardDictionary = solutionsArray[self.currentBoardSelected - 1];
    
    for(id key in temporaryDictionary)
    {
        //UIImageView *currentImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
        UIImageView *currentImageView = [self.model getPuzzlePieceImageView:@"PieceImage" withKey:key];
        NSDictionary *pieceDictionary = [boardDictionary objectForKey:key];
        NSInteger xCoordinate = [self.model getXCoordinate:pieceDictionary];
        NSInteger yCoordinate = [self.model getYCoordinate:pieceDictionary];
        
        CGFloat x = self.boardImageView.frame.origin.x;                 // account for square offset of 30 
        x += xCoordinate*squareDimension;
       
        CGFloat y = self.boardImageView.frame.origin.y;
        y += yCoordinate*squareDimension;
        
        NSInteger rotations = [[pieceDictionary objectForKey:@"rotations"] integerValue];
        NSInteger flips = [[pieceDictionary objectForKey:@"flips"] integerValue];
        
        
        [UIView animateWithDuration:1 animations:^{
        currentImageView.transform = CGAffineTransformRotate(currentImageView.transform, rotations * M_PI/2);
        
        if(flips == 1)
        {
            currentImageView.transform = CGAffineTransformScale(currentImageView.transform, -1, 1);
        }
        
        currentImageView.frame = CGRectMake(x, y, currentImageView.frame.size.width, currentImageView.frame.size.height);
        
        [self.view addSubview:currentImageView];
        }];
    
    }
    

                                  
}

- (IBAction)resetButtonPressed:(id)sender
{
    NSMutableArray *solutionsArray = [self.model getSolutions];
    NSDictionary *boardDictionary;
    solved = NO;
    
        self.resetButton.enabled = NO;
    
    if(self.currentBoardSelected == 0)
    {
        return;
    }
    
    boardDictionary = solutionsArray[self.currentBoardSelected - 1];
    
    NSMutableDictionary *temporaryDictionary = [self.model getPuzzlePieceDictionary];
    
    for(id key in temporaryDictionary)
    {
        UIImageView *currentImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
        
        [UIView animateWithDuration:1 animations:^{
        currentImageView.transform = CGAffineTransformIdentity;
        }];
        
    }    
    
    [UIView animateWithDuration:1 animations:^{
    [self displayPuzzlePieces];
    }];
    }




-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if(solved)
    {
        [self resetButtonPressed:nil];
        
    }
    [UIView animateWithDuration:1 animations:^{
        [self displayPuzzlePieces];
    }];
    
    self.resetButton.enabled = NO;
    
}


-(void)panRecognized:(UIPanGestureRecognizer*)recognizer {

    
    UIView *pannedView = recognizer.view;
    CGPoint newOrigin;
    NSInteger boardX;
    NSInteger boardY;
    NSInteger boardXMax;
    NSInteger boardYMax;
    
    if(self.currentBoardSelected != 0)
    {
        self.resetButton.enabled = YES;
    }
    
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            pannedView.center = [recognizer locationInView:recognizer.view.superview];
            //pannedView.transform = CGAffineTransformScale(pannedView.transform, .8, .8);
            break;
        case UIGestureRecognizerStateChanged:
            pannedView.center = [recognizer locationInView:recognizer.view.superview];
            break;
        case UIGestureRecognizerStateEnded:
            //pannedView.transform = CGAffineTransformIdentity;
            NSLog(@"dragging");
            if([recognizer.view.superview isEqual:self.boardImageView])
            {
                NSLog(@"inside if assinging");
                boardX = 0;
                boardY = 0;
                boardXMax = recognizer.view.superview.frame.size.width;
                boardYMax = recognizer.view.superview.frame.size.height;
            }
            else 
            {
                NSLog(@"inside else assigning");
                boardX = self.boardImageView.frame.origin.x;
                boardY = self.boardImageView.frame.origin.y;
                boardXMax = self.boardImageView.frame.origin.x + self.boardImageView.frame.size.width;
                boardYMax = self.boardImageView.frame.origin.y + self.boardImageView.frame.size.height;
            
            
            }
            
            if((pannedView.center.x > boardX) && (pannedView.center.x < boardXMax) && (pannedView.center.y > boardY) && (pannedView.center.y < boardYMax))
            {
                NSLog(@"Inside first if");
             
                if([recognizer.view.superview isEqual:self.view])
                {
                    NSLog(@"IF!");
                     newOrigin = [self.view convertPoint:pannedView.frame.origin toView:self.boardImageView];
                
                    newOrigin.x = 30 * floor((newOrigin.x/30)+0.5);
                    newOrigin.y = 30 * floor((newOrigin.y/30)+0.5);
                
                    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                    pannedView.frame = newFrame;
                    [self.boardImageView addSubview:pannedView];
                }
                else if([recognizer.view.superview isEqual:self.boardImageView])
                {
                    NSLog(@"Else!");
                    //CGPoint newOrigin;
                    newOrigin.x = 30 * floor((pannedView.frame.origin.x/30)+0.5);
                    newOrigin.y = 30 * floor((pannedView.frame.origin.y/30)+0.5);
                    
                    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                    [recognizer.view setFrame:newFrame];
                    
                }
            }
            else
            {
                newOrigin = [self.boardImageView convertPoint:pannedView.frame.origin toView:self.view];
                CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                pannedView.frame = newFrame;
                [self.view addSubview:pannedView];
                
            }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
        if(self.currentBoardSelected != 0)
        {
            self.resetButton.enabled = YES;
        }
    
        UIView *tappedView = recognizer.view;
    
        tappedView.transform = CGAffineTransformScale(tappedView.transform, -1, 1);

}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    if(self.currentBoardSelected != 0)
    {
        self.resetButton.enabled = YES;
    }
    UIView *doubleTappedView = recognizer.view;
    
    doubleTappedView.transform = CGAffineTransformRotate(doubleTappedView.transform, M_PI/2);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InfoSegue"])
    {
        jjkInfoViewController *infoViewController = segue.destinationViewController;
        infoViewController.delegate = self;
    }
    
}
-(IBAction)unwindSegue:(UIStoryboardSegue*)segue
{
}



@end
