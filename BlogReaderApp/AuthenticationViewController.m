//
//  AuthenticationViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"


@interface AuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *touchIDlabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor mainColor];
    self.touchIDlabel.font = [UIFont regularFont:15];
    self.introductionLabel.font = [UIFont regularFont:20];
}

#pragma localAutentication Touch Id

- (IBAction)authenticationButtonTapped:(UIButton *)sender {
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"success"];

    [self.navigationController pushViewController:controller animated:YES];

//    
//    LAContext *context = [[LAContext alloc] init];
//    
//    NSError *error = nil;
//    
//    NSString *myLocalizedReasonString = @"This is a private diary and needs authentication";
//    
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        // Authenticate User
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
//                localizedReason:myLocalizedReasonString
//                          reply:^(BOOL success, NSError *error) {
//                              dispatch_async(dispatch_get_main_queue(), ^(void){
//                                  
//                                  if (success) {
//                                      [self authenticationSuccesful];
//                                      
//                                  }else {
//                                      switch (error.code) {
//                                          case LAErrorAuthenticationFailed:
//                                              [self authenticationFailed];
//                                              break;
//                                              
//                                          case LAErrorUserCancel:
//                                              [self userPressCancelButtonDuringAuthentication];
//                                              break;
//                                              
//                                          case LAErrorUserFallback:
//                                              [self userPressedEnterPassword];
//                                              break;
//                                              
//                                          default:
//                                              [self touchIdIsNotConfigured];
//                                              break;
//                                      }
//                                      NSLog(@"Authentication Fails");
//                                  }
//                              });
//                          }];
//    } else {
//        [self touchIdIsNotConfigured];
//    }
}


- (void)authenticationSuccesful {
    
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"Authentication was successful"
                                                                          message:@"welcome!"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     
                                                     //HERE GOES THE MAMBO
//                                                     UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"success"];
//                                                     [self.navigationController pushViewController:controller animated:YES];

                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
}

- (void)authenticationFailed {
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"Authentication failed"
                                                                          message:@"please try again"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
    
}

- (void)userPressCancelButtonDuringAuthentication {
    NSLog(@"User pressed Cancel button");
}

- (void)userPressedEnterPassword {
    NSLog(@"User pressed \"Enter Password\"");
}

- (void)touchIdIsNotConfigured {
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"Touch ID is not configured"
                                                                          message:@"Please go to your settings and configure it"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
}






@end
