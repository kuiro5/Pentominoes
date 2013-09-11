//
//  jjkViewController.m
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/10/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkViewController.h"
#define yOffset 110
#define xOffset 10

@interface jjkViewController ()
- (IBAction)solveButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (nonatomic, strong) NSArray *puzzlePieceArray;
@property NSInteger currentBoardSelected;
@end

@implementation jjkViewController

-(NSDictionary*)dictionaryWithImageName:(NSString*)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    NSDictionary *dict = @{@"image":image};
    return dict;
}

-(void)displayPuzzlePieces
{
    self.puzzlePieceArray = [self initializePuzzlePieces];
    
    CGPoint startingPoint = self.boardImageView.frame.origin;
    startingPoint.y += self.boardImageView.frame.size.height;
    startingPoint.y = startingPoint.y + yOffset/2;
    startingPoint.x = startingPoint.x - 4*xOffset;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    //NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    
    
    
    for(UIImageView *puzzlePiece in self.puzzlePieceArray)
    {
        if(currentPoint.x + puzzlePiece.image.size.width >= screenWidth)
        {
            currentPoint.x = startingPoint.x;
            currentPoint.y += yOffset;
            
            puzzlePiece.frame = CGRectMake(currentPoint.x, currentPoint.y, (puzzlePiece.image.size.width)/2, (puzzlePiece.image.size.height)/2);
            
            currentPoint.x += puzzlePiece.image.size.width/2 + xOffset;
            
            
        }
        else
        {
            puzzlePiece.frame = CGRectMake(currentPoint.x, currentPoint.y, puzzlePiece.image.size.width/2, puzzlePiece.image.size.height/2);
            currentPoint.x += puzzlePiece.image.size.width/2 + xOffset;
            
            
        }
        
        [self.view addSubview:puzzlePiece];
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self displayPuzzlePieces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)initializePuzzlePieces
{
    NSArray *initialPuzzlePieceArray = [NSArray arrayWithObjects:@"tileF.png",@"tileI.png",@"tileL.png",@"tileN.png",@"tileP.png",@"tileT.png",@"tileU.png",@"tileV.png",@"tileW.png",@"tileX.png",@"tileY.png",@"tileZ.png", nil];
    
    NSMutableArray *imageViewArray = [NSMutableArray array];
    
    for(NSString *path in initialPuzzlePieceArray)
    {
        UIImage *image = [UIImage imageNamed:path];
        
        CGRect resizeFrame;
        resizeFrame.size.height = image.size.height/*/2*/;
        resizeFrame.size.width = image.size.width/*/2*/;
        
        UIImageView *temporaryPuzzleImageView = [[UIImageView alloc] initWithFrame: resizeFrame];
        temporaryPuzzleImageView.image = image;
        
        [imageViewArray addObject:temporaryPuzzleImageView];
        
    }
    
    return imageViewArray;
    
    
    
    
}

-(IBAction)boardButtonPressed:(id)sender
{
    NSString *boardImageSelected = [NSString stringWithFormat:@"Board%d.png", [sender tag]];
    
    self.boardImageView.image = [UIImage imageNamed:boardImageSelected];
    
    self.currentBoardSelected = [sender tag];
    
}

- (IBAction)solveButtonPressed:(id)sender
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *solutionFile = [bundle pathForResource:@"Solutions" ofType:@".plist"];
    
    NSArray *solutionsArray = [NSArray arrayWithContentsOfFile:solutionFile];
    
    NSNumber *boardSelected = [NSNumber numberWithInt:(_currentBoardSelected -1 );
    
    if(self.currentBoardSelected != 0)
    {
        NSDictionary *boardDictioanry = [solutionsArray objectAtIndex:(self.currentBoardSelected - 1)];
        for(NSString *puzzlePieces in puzzlePieceArray)
        {
            NSString *puzzleKey = [puzzlePieces substringWithRange:NSMakeRange(4,4)];
            NSDictionary *puzzlePieceDictioanry = boardDictionary objectAtKey:@"";
        }
    }
                               
}
@end
