//
// Name:    Joshua Kuiros
// Section: CMPSC 475
// Program: Assignment 3
// Date: September 19, 2013
//

#import <UIKit/UIKit.h>

@protocol InfoDelegate <NSObject>

-(void)dismissMe;

@end

@interface jjkInfoViewController : UIViewController
@property (nonatomic,weak) id<InfoDelegate> delegate;
@end
