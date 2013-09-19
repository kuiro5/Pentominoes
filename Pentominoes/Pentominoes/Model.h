//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
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
