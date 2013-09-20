//
//  MainMenuViewController.h
//  tateti
//
//  Created by Jorge Lorenzon on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *player1;
@property (strong, nonatomic) IBOutlet UITextField *player2;

- (IBAction)play:(id)sender;
@end
