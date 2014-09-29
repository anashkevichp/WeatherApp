//
//  WeatherDetailController.h
//  WeatherApp
//
//  Created by Pavel Anashkevich on 9/29/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeatherDetailController : UITableViewController

@property (nonatomic, strong) Weather *weather;

@end
