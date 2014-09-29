//
//  WeatherViewCell.h
//  WeatherApp
//
//  Created by Pavel Anashkevich on 9/29/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UILabel *tempLabel;

@end
