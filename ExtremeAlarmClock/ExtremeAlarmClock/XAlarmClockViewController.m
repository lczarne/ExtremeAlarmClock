//
//  XAlarmClockViewController.m
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import "XAlarmClockViewController.h"

@interface XAlarmClockViewController ()

@end

@implementation XAlarmClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (!self.motionManager.deviceMotionAvailable) {
        NSLog(@"No device motion");
    }
    else
    {
        NSLog(@"device motion available");

    }
    

	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
