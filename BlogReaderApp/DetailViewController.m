//
//  DetailViewController.m
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DetailViewController.h"
#import "THDiaryEntry.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"hola %@" ,  self.entry.location);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    [self.view endEditing:YES];
}




@end
