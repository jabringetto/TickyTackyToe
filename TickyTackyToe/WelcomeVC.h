//
//  WelcomeVC.h
//  TickyTackyToe
//
//  Created by Jeremy Bringetto on 2/15/16.
//  Copyright © 2016 Jeremy Bringetto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeVC : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
- (IBAction)validateInput:(id)sender;

@end

