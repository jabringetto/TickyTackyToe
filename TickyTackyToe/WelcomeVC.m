//
//  WelcomeVC.m
//  TickyTackyToe
//
//  Created by Jeremy Bringetto on 2/15/16.
//  Copyright © 2016 Jeremy Bringetto. All rights reserved.
//

#import "WelcomeVC.h"
#import "GameVC.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_nField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    _nField.text = @"";
    _enterButton.hidden = YES;
    _enterButton.userInteractionEnabled = NO;
    
}

 #pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    _enterButton.hidden = YES;
    _enterButton.userInteractionEnabled = NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    if(range.length + range.location > textField.text.length)
    {
       
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return newLength <= 1;

}
-(void)textFieldDidChange:(UITextField*)textField
{
    NSCharacterSet *threeThroughEight = [NSCharacterSet characterSetWithCharactersInString:@"345678"];
    BOOL valid = [[textField.text stringByTrimmingCharactersInSet:threeThroughEight] isEqualToString:@""];
    if(valid)
    {
        _enterButton.hidden = NO;
        _enterButton.userInteractionEnabled = YES;
    }
    else
    {
        textField.text = @"";
        _enterButton.hidden = YES;
        _enterButton.userInteractionEnabled = NO;
    }
    [textField resignFirstResponder];
}

#pragma mark - Enter Button validation

- (IBAction)validateInput:(id)sender
{
    NSString *input = _nField.text;
    if([input length] == 1)
    {
        [self performSegueWithIdentifier:@"gameSegue" sender:self];
    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"gameSegue"])
    {
        GameVC *gvc = [segue destinationViewController];
        gvc.gameSizeN =  [_nField.text integerValue];
    }
    
}
@end
