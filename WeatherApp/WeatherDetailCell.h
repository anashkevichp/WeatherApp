//
//  WeatherDetailCell.h
//  WeatherApp
//
//  Created by Pavel Anashkevich on 9/30/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end
