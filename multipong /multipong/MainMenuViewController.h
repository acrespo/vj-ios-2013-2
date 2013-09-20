//
//  MainMenuViewController.h
//  multipong
//
//  Created by Jorge Lorenzon on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MainMenuViewController : UIViewController <GKMatchmakerViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UIButton *newGameButton;

- (IBAction)newGame:(id)sender;

@end
