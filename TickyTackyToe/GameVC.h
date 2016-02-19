//
//  GameVC.h
//  TickyTackyToe
//
//  Created by Jeremy Bringetto on 2/15/16.
//  Copyright © 2016 Jeremy Bringetto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Square.h"

@interface GameVC : UIViewController

@property (nonatomic) NSInteger gameSizeN;
@property (nonatomic) NSInteger player;
@property (nonatomic) NSInteger scorePlayer1;
@property (nonatomic) NSInteger scorePlayer2;
@property (nonatomic) NSMutableArray *squares;
@property (nonatomic) NSInteger numSelected;
@property (nonatomic) CGFloat gameWidth;
@property (nonatomic) CGFloat spacing;
@property (nonatomic) CGFloat greatestYPosition;
@property (nonatomic) UILabel *turnAnnouncer;
@property (nonatomic) UILabel *winsLabel1;
@property (nonatomic) UILabel *winsLabel2;
@property (nonatomic) NSMutableDictionary *winsData;

@end
