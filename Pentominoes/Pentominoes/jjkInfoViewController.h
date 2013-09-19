//
//  jjkInfoViewController.h
//  Pentominoes
//
//  Created by Joshua Kuiros on 9/19/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoDelegate <NSObject>

-(void)dismissMe;

@end

@interface jjkInfoViewController : UIViewController
@property (nonatomic,weak) id<InfoDelegate> delegate;
@end
