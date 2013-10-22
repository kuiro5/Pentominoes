//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 4
// Date: September 26, 2013
//

#import <UIKit/UIKit.h>

@protocol InfoDelegate <NSObject>

-(void)dismissMe;
-(void)changeTheme:(NSInteger)tag;
-(UIColor*)currentTheme;

@end

@interface jjkInfoViewController : UIViewController
@property (retain,nonatomic) id<InfoDelegate> delegate;
@end
