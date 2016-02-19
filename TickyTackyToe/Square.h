//
//  Square.h
//  TickyTackyToe
//
//  Created by Jeremy Bringetto on 2/15/16.
//  Copyright © 2016 Jeremy Bringetto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Square : UIButton

@property (nonatomic) NSInteger squareNumber;
@property (nonatomic) NSInteger rowNumber;
@property (nonatomic) NSInteger columnNumber;

@end
