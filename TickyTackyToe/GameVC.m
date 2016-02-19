//
//  GameVC.m
//  TickyTackyToe
//
//  Created by Jeremy Bringetto on 2/15/16.
//  Copyright © 2016 Jeremy Bringetto. All rights reserved.
//

#import "GameVC.h"

@interface GameVC ()

@end

@implementation GameVC

@synthesize gameSizeN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureGame];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self configureUI];
}
-(void)configureGame
{
    _player = 1;
    _scorePlayer1 = _scorePlayer2 = 0;
    _numSelected = 0;
    _greatestYPosition = 0;
    _spacing = 5.0;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    _gameWidth = screenSize.width-2*_spacing;
    _winsData = [[NSMutableDictionary alloc]init];
}
-(void)configureUI
{
    _squares = [[NSMutableArray alloc]init];
    
    CGFloat spacePerSquare = _gameWidth/gameSizeN;
    CGFloat squareSize = spacePerSquare - _spacing;
    NSInteger row = 0;
    NSInteger column = 0;
    NSInteger N_squared = gameSizeN * gameSizeN;
    for (int i = 0; i < N_squared; i++)
    {
        NSInteger num = i+1;
        float f = i/gameSizeN;
        row = (int)f +1;
        column = i % gameSizeN +1;
        CGFloat xPos = _spacing + (column -1)*spacePerSquare + _spacing/2;
        CGFloat yPos = 120 + (row-1) * spacePerSquare + _spacing/2;
        
        if(yPos > _greatestYPosition)
        {
            _greatestYPosition = yPos;
        }
        
        CGRect frame = CGRectMake(xPos, yPos, squareSize, squareSize);
        Square *s = [[Square alloc]initWithFrame:frame];
        s.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.45 alpha:1];
        s.squareNumber = num;
        s.rowNumber = row;
        s.columnNumber = column;
        [s addTarget:self action:@selector(gameTurn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:s];
        [_squares addObject:s];
    }
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
    [reset addTarget:self action:@selector(resetGame) forControlEvents:UIControlEventTouchUpInside];
    [reset setTitle:@"R E S E T" forState:UIControlStateNormal];
    reset.frame = CGRectMake(_gameWidth/2-40, _greatestYPosition + spacePerSquare*1.1, 100, 20.0);
    [reset setBackgroundColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.35 alpha:1]];
    [self.view addSubview:reset];
    
    _turnAnnouncer = [[UILabel alloc]initWithFrame:CGRectMake(_gameWidth/2-60, 80, 200, 20.0)];
    _turnAnnouncer.text = @"Turn: Player 1 (X)";
    [_turnAnnouncer setTextColor:[UIColor orangeColor]];
    [self.view addSubview:_turnAnnouncer];
    
    [self readWinsDataFromPlistOrWriteNewOne];
    
    _winsLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_spacing, _greatestYPosition + spacePerSquare*1.3, 200, 20.0)];
    NSInteger w1 = [[_winsData objectForKey:@"winsPlayer1"]integerValue];
    _winsLabel1.text = [NSString stringWithFormat:@"Player 1 Wins: %ld",(long)w1];
  
    [_winsLabel1 setTextColor:[UIColor whiteColor]];
    [_winsLabel1 setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_winsLabel1];
    
    CGFloat winsLabel2_xOffset = reset.frame.origin.x + reset.frame.size.width + _spacing*2;
    _winsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(winsLabel2_xOffset, _greatestYPosition + spacePerSquare*1.3, 200, 20.0)];
    NSInteger w2 = [[_winsData objectForKey:@"winsPlayer2"]integerValue];
    _winsLabel2.text = [NSString stringWithFormat:@"Player 2 Wins: %ld",(long)w2];
    [_winsLabel2 setTextColor:[UIColor whiteColor]];
    [_winsLabel2 setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_winsLabel2];
    
}

-(void)gameTurn:(id)sender
{
    Square *s = (Square*)sender;
    [s setEnabled:NO];
    _numSelected += 1;
    switch (_player)
    {
        case 1:
            [s setTitle:@"X" forState:UIControlStateNormal];
            [self checkForWinsOrDraws];
            _player = 2;
            _turnAnnouncer.text = @"Turn: Player 2 (O)";
            break;
        case 2:
            [s setTitle:@"O" forState:UIControlStateNormal];
            [self checkForWinsOrDraws];
            _turnAnnouncer.text = @"Turn: Player 1 (X)";
            _player = 1;
            break;
        default:
            break;
    }
}
-(void)checkForWinsOrDraws
{
    BOOL draw = YES;
    NSString *msg = @"";
    
    int leftDiagScore_X = 0;
    int rightDiagScore_X = 0;
    int leftDiagScore_O = 0;
    int rightDiagScore_O = 0;
    
    for (int j = 1; j <= gameSizeN; j++)
    {
        int rowScore_X = 0;
        int rowScore_O = 0;
        int columnScore_X = 0;
        int columnScore_O = 0;
        
        for (Square *s in _squares)
        {
            
            BOOL rowX = s.rowNumber == j && [s.titleLabel.text isEqualToString:@"X"];
            BOOL rowO = s.rowNumber == j && [s.titleLabel.text isEqualToString:@"O"];
            BOOL columnX = s.columnNumber == j && [s.titleLabel.text isEqualToString:@"X"];
            BOOL columnO = s.columnNumber == j && [s.titleLabel.text isEqualToString:@"O"];
            
            NSInteger reverseIndex = (gameSizeN - j) +1;
            BOOL columnReverse_X = s.columnNumber == reverseIndex && [s.titleLabel.text isEqualToString:@"X"];
            BOOL columnReverse_O = s.columnNumber == reverseIndex && [s.titleLabel.text isEqualToString:@"O"];
            
            if(rowX)
            {
                rowScore_X += 1;
            }
            else if(rowO)
            {
                rowScore_O += 1;
            }
            
            if(columnX)
            {
                columnScore_X += 1;
            }
            else if(columnO)
            {
                columnScore_O += 1;
            }
            if(rowX && columnX)
            {
                leftDiagScore_X += 1;
            }
            if(rowO && columnO)
            {
                leftDiagScore_O += 1;
            }
            if(rowX && columnReverse_X)
            {
                rightDiagScore_X += 1;
            }
            if(rowO && columnReverse_O)
            {
                rightDiagScore_O += 1;
            }
            
        }
        if(rowScore_X == gameSizeN)
        {
            draw = NO;
            msg = @"Player 1 wins by completing a row.";
            [self recordWinsToPlist:1];
            
        }
        if(rowScore_O == gameSizeN)
        {
            draw = NO;
            msg = @"Player 2 wins by completing a row.";
            [self recordWinsToPlist:2];
        }
        if(columnScore_X == gameSizeN)
        {
            draw = NO;
            msg = @"Player 1 wins by completing a column.";
            [self recordWinsToPlist:1];
        }
        if(columnScore_O == gameSizeN)
        {
            draw = NO;
            msg = @"Player 2 wins by completing a column.";
            [self recordWinsToPlist:2];
        }
        if(leftDiagScore_X == gameSizeN)
        {
            draw = NO;
            msg = @"Player 1 wins by completing a diagonal.";
            [self recordWinsToPlist:1];
        }
        if(rightDiagScore_X == gameSizeN)
        {
            draw = NO;
            msg = @"Player 1 wins by completing a diagonal.";
            [self recordWinsToPlist:1];
        }
        if(leftDiagScore_O == gameSizeN)
        {
            draw = NO;
            msg = @"Player 2 wins by completing a diagonal.";
            [self recordWinsToPlist:2];
        }
        if(rightDiagScore_O == gameSizeN)
        {
            draw = NO;
            msg = @"Player 2 wins by completing a diagonal.";
            [self recordWinsToPlist:2];
        }
        
        if(!draw)
        {
            [self announceTheResult:@"CONGRATULATIONS":msg];
        }
        
    }
    if(draw && _numSelected == gameSizeN*gameSizeN)
    {
        msg = @"Well played. Time for a rematch?";
        [self announceTheResult:@"It's a draw!":msg];
    }
}
-(void)announceTheResult:(NSString*)title :(NSString *)msg
{
    UIAlertController *announcer= [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [self dismissViewControllerAnimated:NO completion:^(void){}];
        [self resetGame];
        
    }];
    
    [announcer addAction:ok];
    
    [self presentViewController:announcer animated:YES completion:nil];
}
-(void)resetGame
{
    for (UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    [self configureGame];
    [self viewWillAppear:NO];
}
-(NSString*)plistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *winsDataPath = [documentsPath stringByAppendingPathComponent:@"winsData.plist"];
    return winsDataPath;
}

-(void)readWinsDataFromPlistOrWriteNewOne
{
    NSString *path = [self plistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL winsDataExits = [fileManager fileExistsAtPath:path];
    if(winsDataExits)
    {
        _winsData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    else
    {
        NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
        [d setObject:[NSNumber numberWithInteger:0] forKey:@"winsPlayer1"];
        [d setObject:[NSNumber numberWithInteger:0] forKey:@"winsPlayer2"];
        [d writeToFile:path atomically:YES];
    }
    
}
-(void)recordWinsToPlist:(NSInteger)winningPlayer
{
     NSString *path = [self plistPath];
    _winsData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if(winningPlayer == 1)
    {
        NSInteger wins = [[_winsData objectForKey:@"winsPlayer1"]integerValue] +1;
        [_winsData setObject:[NSNumber numberWithInteger:wins] forKey:@"winsPlayer1"];
    }
    else if(winningPlayer == 2)
    {
        NSInteger wins = [[_winsData objectForKey:@"winsPlayer2"]integerValue] +1;
        [_winsData setObject:[NSNumber numberWithInteger:wins] forKey:@"winsPlayer2"];
    }
    [_winsData writeToFile:path atomically:YES];
}



@end
