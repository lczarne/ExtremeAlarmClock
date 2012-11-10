//
//  AlarmViewController.m
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import "AlarmViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface AlarmViewController ()

@end

@implementation AlarmViewController


- (void)startSampling
{
    self.motionManager.showsDeviceMovementDisplay = YES;
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        [self.motionManager startGyroUpdates];
        NSOperationQueue *operationQ = [NSOperationQueue currentQueue];
        
        [self.motionManager startDeviceMotionUpdatesToQueue:operationQ withHandler:^(CMDeviceMotion *motion, NSError *error){
            NSLog(@"x: %f y: %f z:%f",motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
            
            self.xLabel.text = [NSString stringWithFormat:@"x: %f",motion.userAcceleration.x];
            self.yLabel.text = [NSString stringWithFormat:@"y: %f",motion.userAcceleration.y];
            self.zLabel.text = [NSString stringWithFormat:@"z: %f",motion.userAcceleration.z];
            
            
            if (motion.userAcceleration.x > 0.4) {
                self.testLabel.text = @"prawo";
            }
            if (motion.userAcceleration.x < (-0.4)) {
                self.testLabel.text = @"lewo";
            }
            if (motion.userAcceleration.y > 0.4) {
                self.testLabel.text = @"gora";
            }
            if (motion.userAcceleration.y < (-0.4)) {
                self.testLabel.text = @"dol";
            }
            
        }];
        
    } else {
        NSLog(@"No gyroscope on device.");
    }
}

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.deviceMotionAvailable) {
        [self startSampling];
    }
    else {
        NSLog(@"no device motion");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
