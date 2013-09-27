//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 4
// Date: September 26, 2013
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

-(NSMutableDictionary*)puzzleDictionary;

-(NSArray*)initializePuzzlePieces;
-(void)initializeSolutions;

-(NSMutableArray*)solutions;

-(UIImageView*)puzzlePieceImageView:(NSString*)view withKey:(id)key;
-(UIImage*)boardImage:(NSInteger)tag;



@end
