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

-(void)initializePuzzlePieces
{
    NSArray *initialPuzzlePieceArray = [NSArray arrayWithObjects:@"tileF.png",@"tileI.png",@"tileL.png",@"tileN.png",@"tileP.png",@"tileT.png",@"tileU.png",@"tileV.png",@"tileW.png",@"tileX.png",@"tileY.png",@"tileZ.png", nil];
    
    
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
        [_puzzlePieceDictionary setObject:propertiesDictionary forKey:[path substringWithRange:keyRange]];
    }
}

-(NSMutableDictionary*)getPuzzlePieceDictionary
{
    return _puzzlePieceDictionary;
}

-(void)initializeSolutions
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *solutionFile = [bundle pathForResource:@"Solutions" ofType:@".plist"];
    _solutionsArray = [NSArray arrayWithContentsOfFile:solutionFile];
}

-(NSMutableArray*)getSolutions
{
    return _solutionsArray;
}

-(UIImageView*)getPuzzlePieceImageView:(NSString*)view withKey:(id)key
{
    UIImageView *currentImageView = [[_puzzlePieceDictionary objectForKey:key] objectForKey:view];
    return currentImageView;
}

-(NSInteger)getXCoordinate:(NSDictionary*)dictionary
{
    NSInteger xVal = [[dictionary objectForKey:@"x"] integerValue];
    return xVal;
}

-(NSInteger)getYCoordinate:(NSDictionary*)dictionary
{
    NSInteger yVal = [[dictionary objectForKey:@"y"] integerValue];
    return yVal;
}

-(NSString*)getBoardImage:(NSInteger)tag
{
    NSString* boardImage = [NSString stringWithFormat:@"Board%d.png",  tag];
    
    return boardImage;
}

@end
