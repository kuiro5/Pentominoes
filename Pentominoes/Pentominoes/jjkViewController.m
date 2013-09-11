//
//  jjkViewController.m
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/10/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkViewController.h"
#define yOffset 10
#define xOffset 10

@interface jjkViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (nonatomic, strong) NSArray *puzzlePieceArray;
@end

@implementation jjkViewController

-(NSDictionary*)dictionaryWithImageName:(NSString*)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    NSDictionary *dict = @{@"image":image};
    return dict;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.puzzlePieceArray = [self displayPuzzlePieces];
    
    CGPoint startingPoint = self.boardImageView.frame.origin;
    startingPoint.y += self.boardImageView.frame.size.height;
    startingPoint.y = startingPoint.y + 5*yOffset;
    startingPoint.x = startingPoint.x - 3*xOffset;
    
    CGPoint currentPoint = startingPoint;
    
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSInteger maximumHeight;
    
    
    
    for(UIImageView *puzzlePiece in self.puzzlePieceArray)
    {
        if(currentPoint.x + puzzlePiece.image.size.width >= screenWidth)
        {
            currentPoint.x = startingPoint.x;
            currentPoint.y += puzzlePiece.image.size.height + yOffset;
            
            puzzlePiece.frame = CGRectMake(currentPoint.x, currentPoint.y, (puzzlePiece.image.size.width)/2, (puzzlePiece.image.size.height)/2);
            
            currentPoint.x += puzzlePiece.image.size.width/2 + xOffset;
            
     
        }
        else
        {
            puzzlePiece.frame = CGRectMake(currentPoint.x, currentPoint.y, puzzlePiece.image.size.width/2, puzzlePiece.image.size.height/2);
            currentPoint.x += puzzlePiece.image.size.width/2 + xOffset;
            
     
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)displayPuzzlePieces
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
    
}

@end
