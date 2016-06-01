//
//  AuthenticationViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma localAutentication Touch Id

- (IBAction)authenticationButtonTapped:(UIButton *)sender {
    
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    NSString *myLocalizedReasonString = @"Used for quick and secure access to the test app";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // Authenticate User
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                localizedReason:myLocalizedReasonString
                          reply:^(BOOL success, NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^(void){
                                  
                                  if (success) {
                                      [self authenticationSuccesful];
                                      
                                  }else {
                                      switch (error.code) {
                                          case LAErrorAuthenticationFailed:
                                              [self authenticationFailed];
                                              break;
                                              
                                          case LAErrorUserCancel:
                                              [self userPressCancelButtonDuringAuthentication];
                                              break;
                                              
                                          case LAErrorUserFallback:
                                              [self userPressedEnterPassword];
                                              break;
                                              
                                          default:
                                              [self touchIdIsNotConfigured];
                                              break;
                                      }
                                      NSLog(@"Authentication Fails");
                                  }
                              });
                          }];
    } else {
        [self deviceDontCountWithTouchId];
    }
}


- (void)authenticationSuccesful {
    
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                          message:@"welcome!"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     
                                                     //HERE GOES THE MAMBO
                                                     UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"successnns"];
                                                     [self.navigationController pushViewController:controller animated:YES];

                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
}

- (void)authenticationFailed {
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"Fail"
                                                                          message:@"Authentication failed"
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
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@""
                                                                          message:@"Touch Id is not configured"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
}

- (void)deviceDontCountWithTouchId {
    UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:@"error"
                                                                          message:@"Your device cannot authenticate using TouchID."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                 }];
    [settingAlert addAction:ok];
    [self presentViewController:settingAlert animated:YES completion:nil];
}




@end
