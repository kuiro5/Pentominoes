//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 2
// Date: September 13, 2013
//

#import "jjkViewController.h"
#define yOffset 110
#define xOffset 10
#define squareDimension 30

@interface jjkViewController ()
- (IBAction)solveButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (nonatomic, strong) NSMutableDictionary *puzzlePieceDictionary;
@property NSInteger currentBoardSelected;
@end

BOOL solved = NO;

@implementation jjkViewController


-(void)displayPuzzlePieces
{
    
    
    CGPoint startingPoint = self.boardImageView.frame.origin;               // find boards origins
    startingPoint.y += self.boardImageView.frame.size.height;
    startingPoint.y = startingPoint.y + yOffset/2;
    startingPoint.x = startingPoint.x - 4*xOffset;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;        // get screen width to use for bounds
    
    
    for(id key in self.puzzlePieceDictionary)
    {
        UIImageView *temporaryImageView = [[self.puzzlePieceDictionary objectForKey:key] objectForKey:@"PieceImage"];
       // NSNumber *temporaryRotations = [[self.puzzlePieceDictionary objectForKey:key] objectForKey:@"rotations"];
        //NSNumber *temporaryFlips = [[self.puzzlePieceDictionary objectForKey:key] objectForKey:@"flips"];
        
        if(currentPoint.x + temporaryImageView.frame.size.width >= screenWidth)         // line break
        {
            currentPoint.x = startingPoint.x;
            currentPoint.y += yOffset;
            
            temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
            
            currentPoint.x += temporaryImageView.image.size.width + xOffset;
            
            
        }
        else                                                                    // add piece to current row 
        {
            temporaryImageView.frame = CGRectMake(currentPoint.x, currentPoint.y, temporaryImageView.frame.size.width, temporaryImageView.frame.size.height);
            currentPoint.x += temporaryImageView.image.size.width/2 + xOffset;
            
            
        }
        
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
    
    _puzzlePieceDictionary = [self initializePuzzlePieces];
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

-(NSMutableDictionary*)initializePuzzlePieces
{
    NSArray *initialPuzzlePieceArray = [NSArray arrayWithObjects:@"tileF.png",@"tileI.png",@"tileL.png",@"tileN.png",@"tileP.png",@"tileT.png",@"tileU.png",@"tileV.png",@"tileW.png",@"tileX.png",@"tileY.png",@"tileZ.png", nil];
    
    NSMutableDictionary *piecesDictionary = [NSMutableDictionary dictionary];
    
    NSRange keyRange;                                   // used to retrieve the specific tile's key 
    keyRange.length = 1;
    keyRange.location = 4;
    
    for(NSString *path in initialPuzzlePieceArray)
    {
        UIImage *image = [UIImage imageNamed:path];
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionary];
        
        UIImageView *temporaryPuzzleImageView = [[UIImageView alloc] initWithImage:image];
        temporaryPuzzleImageView.frame = CGRectMake(0,0, image.size.width/2, image.size.height/2);
        
        [propertiesDictionary setObject:temporaryPuzzleImageView forKey:@"PieceImage" ];
        [piecesDictionary setObject:propertiesDictionary forKey:[path substringWithRange:keyRange]];
        
    }
    
    return piecesDictionary;
}



-(IBAction)boardButtonPressed:(id)sender
{
    if(solved == YES)
    {
        [self resetButtonPressed:nil];
    }
    
    solved = NO;
    
    NSString *boardImageSelected = [NSString stringWithFormat:@"Board%d.png", [sender tag]];        // tag corresponds to specific Board, i.e. Board 1 has a tag of 1
    
    self.boardImageView.image = [UIImage imageNamed:boardImageSelected];
    
    self.currentBoardSelected = [sender tag];
    
    self.resetButton.enabled = NO;
    
    
}

- (IBAction)solveButtonPressed:(id)sender
{
    solved = YES;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *solutionFile = [bundle pathForResource:@"Solutions" ofType:@".plist"];
    NSArray *solutionsArray = [NSArray arrayWithContentsOfFile:solutionFile];
    NSDictionary *boardDictionary;
    
    
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
    
    for(id key in self.puzzlePieceDictionary)
    {
        UIImageView *currentImageView = [[self.puzzlePieceDictionary objectForKey:key] objectForKey:@"PieceImage"];
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

- (IBAction)resetButtonPressed:(id)sender
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *solutionFile = [bundle pathForResource:@"Solutions" ofType:@".plist"];
    NSArray *solutionsArray = [NSArray arrayWithContentsOfFile:solutionFile];
    NSDictionary *boardDictionary;
    solved = NO;
    
    self.resetButton.enabled = NO;
    
    if(self.currentBoardSelected == 0)
    {
        return;
    }
    
    boardDictionary = solutionsArray[self.currentBoardSelected - 1];
    
    for(id key in self.puzzlePieceDictionary)
    {
        UIImageView *currentImageView = [[self.puzzlePieceDictionary objectForKey:key] objectForKey:@"PieceImage"];
        NSDictionary *pieceDictionary = [boardDictionary objectForKey:key];
        NSInteger xCoordinate = [[pieceDictionary objectForKey:@"x"] integerValue];
        NSInteger yCoordinate = [[pieceDictionary objectForKey:@"y"] integerValue];
        
        CGFloat x = self.boardImageView.frame.origin.x;
        x += xCoordinate*squareDimension;
        
        CGFloat y = self.boardImageView.frame.origin.y;
        y += yCoordinate*squareDimension;
        
        NSInteger rotations = [[pieceDictionary objectForKey:@"rotations"] integerValue];
        NSInteger flips = [[pieceDictionary objectForKey:@"flips"] integerValue];
        
        
       [UIView animateWithDuration:1 animations:^{
        if(flips == 1)                                  // undo flips
        {
            currentImageView.transform = CGAffineTransformScale(currentImageView.transform, -1, 1);
        }
        
        // undo rotations
        currentImageView.transform = CGAffineTransformRotate(currentImageView.transform, -(rotations * M_PI/2));
        
        currentImageView.frame = CGRectMake(x, y, currentImageView.frame.size.width, currentImageView.frame.size.height);
        
       }];
        
    }    
    
    [UIView animateWithDuration:1 animations:^{
    [self displayPuzzlePieces];
    }];
    }
@end
