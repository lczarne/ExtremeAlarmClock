//
//  AlarmViewController.h
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface AlarmViewController : UIViewController
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;

@end
