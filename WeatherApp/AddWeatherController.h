//
//  AddWeatherController.h
//  WeatherApp
//
//  Created by Pavel Anashkevich on 10/1/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWeatherController : UIViewController

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) IBOutlet UITextField *name;

@end
