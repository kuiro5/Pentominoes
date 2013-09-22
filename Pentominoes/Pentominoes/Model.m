//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
//

#import "Model.h"

@interface Model ()
@property(nonatomic, strong)NSMutableDictionary *puzzlePieceDictionary;
@property(nonatomic, strong)NSMutableArray *solutionsArray;

@end



@implementation Model

-(id)init {
    self = [super init];
    if (self)
    {
        _puzzlePieceDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSArray*)initializePuzzlePieces
{
    NSArray *initialPuzzlePieceArray = [NSArray arrayWithObjects:@"tileF.png",@"tileI.png",@"tileL.png",@"tileN.png",@"tileP.png",@"tileT.png",@"tileU.png",@"tileV.png",@"tileW.png",@"tileX.png",@"tileY.png",@"tileZ.png", nil];
    
    return initialPuzzlePieceArray;
}

-(NSMutableDictionary*)puzzleDictionary
{
    return _puzzlePieceDictionary;
}

-(void)initializeSolutions
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *solutionFile = [bundle pathForResource:@"Solutions" ofType:@".plist"];
    _solutionsArray = [NSArray arrayWithContentsOfFile:solutionFile];
}

-(NSMutableArray*)solutions
{
    return _solutionsArray;
}

-(UIImageView*)puzzlePieceImageView:(NSString*)view withKey:(id)key
{
    UIImageView *currentImageView = [[_puzzlePieceDictionary objectForKey:key] objectForKey:view];
    return currentImageView;
}

-(UIImage*)boardImage:(NSInteger)tag
{
    NSString* boardImage = [NSString stringWithFormat:@"Board%d.png",  tag];
    UIImage *newImage = [UIImage imageNamed:boardImage];
    
    return newImage;
}

@end
