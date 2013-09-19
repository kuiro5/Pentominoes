//
//  Model.h
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/16/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

-(NSMutableDictionary*)getPuzzlePieceDictionary;

-(void)initializePuzzlePieces;
-(void)initializeSolutions;

-(NSMutableArray*)getSolutions;
-(UIImageView*)getPuzzlePieceImageView:(NSString*)view withKey:(id)key;

-(NSInteger)getXCoordinate:(NSDictionary*)dictionary;
-(NSInteger)getYCoordinate:(NSDictionary*)dictionary;

-(NSString*)getBoardImage:(NSInteger)tag;

@end
