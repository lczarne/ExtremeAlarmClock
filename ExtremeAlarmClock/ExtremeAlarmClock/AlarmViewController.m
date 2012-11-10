//
//  AlarmViewController.m
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)startSampling
{
    self.motionManager.showsDeviceMovementDisplay = YES;
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        [self.motionManager startGyroUpdates];
        NSOperationQueue *operationQ = [NSOperationQueue currentQueue];
        
        [self.motionManager startDeviceMotionUpdatesToQueue:operationQ withHandler:^(CMDeviceMotion *motion, NSError *error){
            NSLog(@"x: %f y: %f z:%f",motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
        }];
        
    } else {
        NSLog(@"No gyroscope on device.");
    }
}

- (void)viewDidLoad
{
    [self startSampling];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
