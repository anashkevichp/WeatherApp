//
//  AddWeatherController.m
//  WeatherApp
//
//  Created by Pavel Anashkevich on 10/1/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "AddWeatherController.h"

@interface AddWeatherController ()

@end

@implementation AddWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"doneSegue"]) {
        self.city = [[self name] text];
    }
}

@end
