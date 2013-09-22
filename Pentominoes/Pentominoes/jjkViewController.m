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
#define roundValue .5
#define startingYOffset 55
#define startingXRatio 3

@interface jjkViewController () <InfoDelegate>
- (IBAction)solveButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *temporaryImageView;

@property NSInteger currentBoardSelected;
@property (nonatomic,strong) Model *model;

-(IBAction)unwindSegue:(UIStoryboardSegue*)segue;
@end


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

-(void)createPuzzlePieces;
{
    NSArray *puzzlePieces = [self.model initializePuzzlePieces];
    NSMutableDictionary *pieceDictionary = [self.model puzzleDictionary];
    
    NSRange keyRange;                                   // used to retrieve the specific tile's key
    keyRange.length = 1;
    keyRange.location = 4;
    
    for(NSString *path in puzzlePieces)
    {
        
        UIImage *image = [UIImage imageNamed:path];
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionary];
        
        UIImageView *temporaryPuzzleImageView = [[UIImageView alloc] initWithImage:image];
        temporaryPuzzleImageView.frame = CGRectMake(0,0, image.size.width/2, image.size.height/2);
        
        [propertiesDictionary setObject:temporaryPuzzleImageView forKey:@"PieceImage" ];
        [pieceDictionary setObject:propertiesDictionary forKey:[path substringWithRange:keyRange]];
    }
}

-(void)displayPuzzlePieces
{
    NSLog(@"display called");
    
    UIImageView *temporaryImageView;
    CGPoint startingPoint = self.boardImageView.frame.origin;               // find boards origins
    startingPoint.y += self.boardImageView.frame.size.height + startingYOffset;
    startingPoint.x = (self.boardImageView.frame.origin.x)/startingXRatio;               // 30% off the edge of the screen
    
    CGPoint rightEdge;
    rightEdge.x = self.boardImageView.frame.origin.x + self.boardImageView.frame.size.width;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = self.view.bounds.size.width;                    // get screen width to use for bounds
    
    NSMutableDictionary *temporaryDictionary = [self.model puzzleDictionary];
    
    for(id key in temporaryDictionary)
    {
        temporaryImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
        
        if(currentPoint.x + temporaryImageView.image.size.width/2 >= screenWidth - screenBuffer)        // line break
        {
            currentPoint.x = startingPoint.x;
            currentPoint.y += yOffset;
            
            temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
            
            currentPoint.x += temporaryImageView.image.size.width/2 + xOffset;
            
            
        }
        else                                                                    // add piece to current row 
        {
            temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
            currentPoint.x += temporaryImageView.image.size.width/2 + xOffset;
            
            
        }
        
        temporaryImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
         UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];               

        doubleTap.numberOfTapsRequired = 2;

        
        [temporaryImageView addGestureRecognizer:singleTap];
        [temporaryImageView addGestureRecognizer:doubleTap];
        [temporaryImageView addGestureRecognizer:panGesture];
        
        [self.view addSubview:temporaryImageView];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewDidAppear:(BOOL)animated
{
    
    //[self.model initializePuzzlePieces];
    [self createPuzzlePieces];
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
    
    NSInteger board = [sender tag];
    
    self.boardImageView.image = [self.model boardImage:board];
   
    self.currentBoardSelected = [sender tag];
    self.resetButton.enabled = NO;
}

- (IBAction)solveButtonPressed:(id)sender
{
    NSArray *solutionsArray = [self.model solutions];
    NSDictionary *boardDictionary;
    
    NSMutableDictionary *temporaryDictionary = [self.model puzzleDictionary];
    
    
    if(self.currentBoardSelected != 0)                  // no solution exists for board 0
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
        UIImageView *currentImageView = [self.model puzzlePieceImageView:@"PieceImage" withKey:key];
        NSDictionary *pieceDictionary = [boardDictionary objectForKey:key];
        NSInteger xCoordinate = [[pieceDictionary objectForKey:@"x"] integerValue];
        NSInteger yCoordinate = [[pieceDictionary objectForKey:@"y"] integerValue];
        
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

-(void)rotateDisplayPieces
{
    UIImageView *temporaryImageView;
    CGPoint startingPoint = self.boardImageView.frame.origin;               // find boards origins
    startingPoint.y += self.boardImageView.frame.size.height + startingYOffset;
    startingPoint.x = (self.boardImageView.frame.origin.x)/startingXRatio;               // 30% off the edge of the screen
    
    CGPoint rightEdge;
    rightEdge.x = self.boardImageView.frame.origin.x + self.boardImageView.frame.size.width;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = self.view.bounds.size.width;                    // get screen width to use for bounds
    
    NSMutableDictionary *temporaryDictionary = [self.model puzzleDictionary];
    
    
    for(id key in temporaryDictionary)
    {
        
        
        temporaryImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
        
        
        if([temporaryImageView.superview isEqual:super.view])
        {
            
            if(currentPoint.x + temporaryImageView.image.size.width/2 >= screenWidth - screenBuffer)        // line break
            {
                currentPoint.x = startingPoint.x;
                currentPoint.y += yOffset;
                
                temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
                
                currentPoint.x += temporaryImageView.image.size.width/2 + xOffset;
                
                
            }
            else                                                                    // add piece to current row
            {
                temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
                currentPoint.x += temporaryImageView.image.size.width/2 + xOffset;
                
                
            }
            
            temporaryImageView.userInteractionEnabled = YES;
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            
            [singleTap requireGestureRecognizerToFail:doubleTap];
            
            doubleTap.numberOfTapsRequired = 2;
            
            
            [temporaryImageView addGestureRecognizer:singleTap];
            [temporaryImageView addGestureRecognizer:doubleTap];
            [temporaryImageView addGestureRecognizer:panGesture];
            
            
            [self.view addSubview:temporaryImageView];
        }
    }
}

- (IBAction)resetButtonPressed:(id)sender
{
    self.resetButton.enabled = NO;
    
    
    NSMutableDictionary *temporaryDictionary = [self.model puzzleDictionary];
    
    for(id key in temporaryDictionary)
    {
        UIImageView *currentImageView = [[temporaryDictionary objectForKey:key] objectForKey:@"PieceImage"];
      
        if([currentImageView.superview isEqual:super.view])
        {
            NSLog(@"main view");
            
            [UIView animateWithDuration:1 animations:^{
                currentImageView.transform = CGAffineTransformIdentity;
            }];
        }
        
            
    
    }
    [UIView animateWithDuration:1 animations:^{
        [self rotateDisplayPieces];
    
        }];
         
    
}




-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resetButtonPressed:self];
    
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
            break;
        case UIGestureRecognizerStateChanged:
            pannedView.center = [recognizer locationInView:recognizer.view.superview];
            break;
        case UIGestureRecognizerStateEnded:
            
            if([recognizer.view.superview isEqual:self.boardImageView])                         // set coordinates based off of board image
            {
                boardX = 0;
                boardY = 0;
                boardXMax = recognizer.view.superview.frame.size.width;
                boardYMax = recognizer.view.superview.frame.size.height;
            }
            else                                                                                // set coordinates based off of main view
            {
                boardX = self.boardImageView.frame.origin.x;
                boardY = self.boardImageView.frame.origin.y;
                boardXMax = self.boardImageView.frame.origin.x + self.boardImageView.frame.size.width;
                boardYMax = self.boardImageView.frame.origin.y + self.boardImageView.frame.size.height;
            
            
            }
            
            // piece is being dragged on board image 
            if((pannedView.center.x > boardX) && (pannedView.center.x < boardXMax) && (pannedView.center.y > boardY) && (pannedView.center.y < boardYMax))
            {
             
                if([recognizer.view.superview isEqual:self.view])                                                   // dragging piece from main view to board
                {
                     newOrigin = [self.view convertPoint:pannedView.frame.origin toView:self.boardImageView];
                
                    newOrigin.x = squareDimension * floor((newOrigin.x/squareDimension)+roundValue);
                    newOrigin.y = squareDimension * floor((newOrigin.y/squareDimension)+roundValue);
                
                    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                    pannedView.frame = newFrame;
                    [self.boardImageView addSubview:pannedView];
                }
                else if([recognizer.view.superview isEqual:self.boardImageView])                                    // dragging piece around on board 
                {
                    newOrigin.x = squareDimension * floor((pannedView.frame.origin.x/squareDimension)+roundValue);
                    newOrigin.y = squareDimension * floor((pannedView.frame.origin.y/squareDimension)+roundValue);
                    
                    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                    [recognizer.view setFrame:newFrame];
                    
                }
            }
            else                    // piece is being dragged on main view
            {
                if([recognizer.view.superview isEqual:self.boardImageView])
                {
                    newOrigin = [self.boardImageView convertPoint:pannedView.frame.origin toView:self.view];
                     CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width, pannedView.frame.size.height);
                     pannedView.frame = newFrame;
                     [self.view addSubview:pannedView];
                }
                
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
    
        [UIView animateWithDuration:.5 animations:^{
            tappedView.transform = CGAffineTransformScale(tappedView.transform, -1, 1);
        }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    if(self.currentBoardSelected != 0)
    {
        self.resetButton.enabled = YES;
    }
    UIView *doubleTappedView = recognizer.view;
    
    [UIView animateWithDuration:.5 animations:^{
        doubleTappedView.transform = CGAffineTransformRotate(doubleTappedView.transform, M_PI/2);
    }];
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
