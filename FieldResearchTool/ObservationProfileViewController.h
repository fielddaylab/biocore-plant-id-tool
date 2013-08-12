//
//  ObservationProfileViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ObservationProfileViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager* locationManager;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
