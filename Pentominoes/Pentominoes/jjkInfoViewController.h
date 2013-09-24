//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
//

#import <UIKit/UIKit.h>

@protocol InfoDelegate <NSObject>

-(void)dismissMe;
-(void)changeTheme:(NSInteger)tag;

@end

@interface jjkInfoViewController : UIViewController
@property (strong,nonatomic) id<InfoDelegate> delegate;
@end
