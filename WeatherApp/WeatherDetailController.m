//
//  WeatherDetailController.m
//  WeatherApp
//
//  Created by Pavel Anashkevich on 9/29/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "WeatherDetailController.h"
#import "WeatherDetailCell.h"

#define TEMPRETURE_SECTION 0
#define OTHER_SECTION 1
#define FORECAST_SECTION 2

#define CUR_TEMPRETURE_ROW 0
#define MIN_TEMPRETURE_ROW 1
#define MAX_TEMPRETURE_ROW 2

#define WIND_ROW 0
#define HUMIDITY_ROW 1
#define PRESSURE_ROW 2
#define CLOUD_COVER_ROW 3

#define RAIN_FORECAST_ROW 0
#define SNOW_FORECAST_ROW 1

@interface WeatherDetailController ()

@end

@implementation WeatherDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case TEMPRETURE_SECTION:
            return 3;
        case OTHER_SECTION:
            return 4;
        case FORECAST_SECTION:
            return 2;
        default:
            return 0;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case TEMPRETURE_SECTION:
            return @"Tempreture";
        case OTHER_SECTION:
            return @"Other";
        case FORECAST_SECTION:
            return @"Forecast (3 hours)";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeatherDetailIdentifier";
    WeatherDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[WeatherDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    long section = [indexPath section];
    long row = [indexPath row];
    
    switch (section) {
            
        case TEMPRETURE_SECTION:
            switch (row) {
                case CUR_TEMPRETURE_ROW:
                    cell.nameLabel.text = @"Current";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f°", [[self weather] currentTempreture]];
                    cell.valueLabel.textColor = [UIColor greenColor];
                    break;
                case MIN_TEMPRETURE_ROW:
                    cell.nameLabel.text = @"Minimum";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f°", [[self weather] minTempreture]];
                    cell.valueLabel.textColor = [UIColor blueColor];
                    break;
                case MAX_TEMPRETURE_ROW:
                    cell.nameLabel.text = @"Maximum";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f°", [[self weather] maxTempreture]];
                    cell.valueLabel.textColor = [UIColor redColor];
                    break;
                
            }
            break;
            
        case OTHER_SECTION:
            switch (row) {
                case WIND_ROW:
                    cell.nameLabel.text = @"Wind speed";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f m/s", [[self weather] windSpeed]];
                    break;
                case HUMIDITY_ROW:
                    cell.nameLabel.text = @"Humidity";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%i%%", [[self weather] humidity]];
                    break;
                case PRESSURE_ROW:
                    cell.nameLabel.text = @"Pressure";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%i hPa", [[self weather] pressure]];
                    break;
                case CLOUD_COVER_ROW:
                    cell.nameLabel.text = @"Cloud cover";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%i%%", [[self weather] cloudCover]];
                    break;
            }
            break;
        
        case FORECAST_SECTION:
            switch (row) {
                case HUMIDITY_ROW:
                    cell.nameLabel.text = @"Chance of rain";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%i mm", [[self weather] rain3hours]];
                    break;
                case WIND_ROW:
                    cell.nameLabel.text = @"Chance of snow";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%i mm", [[self weather] snow3hours]];
                    break;
            }
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
