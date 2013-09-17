//
//  Model.m
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/16/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "Model.h"

@interface Model ()

@end

@implementation Model

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
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

@end
