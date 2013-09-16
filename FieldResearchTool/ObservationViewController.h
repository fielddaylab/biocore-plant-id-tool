//
//  ObservationViewController.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreLocation/CoreLocation.h>

#import "Project.h"
#import "ObservationContainerViewController.h"
#import "UserObservation.h"

@interface ObservationViewController : UIViewController<ObservationContainerViewControllerDelegate/*,  CLLocationManagerDelegate*/> {
    //CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) BOOL newObservation;
@property (strong, nonatomic) UserObservation *prevObservation;

@end
