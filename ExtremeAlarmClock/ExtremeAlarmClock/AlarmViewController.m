//
//  AlarmViewController.m
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import "AlarmViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "Constants.h"

@interface AlarmViewController ()
@property double max;
@property double min;
@property double distance;
@property BOOL counting;
@end

@implementation AlarmViewController


- (void)startSampling
{
    self.motionManager.showsDeviceMovementDisplay = YES;
    if (self.motionManager.deviceMotionAvailable) {
        //self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        [self.motionManager startGyroUpdates];
        NSOperationQueue *operationQ = [NSOperationQueue currentQueue];
    
        
        [self.motionManager startDeviceMotionUpdatesToQueue:operationQ withHandler:^(CMDeviceMotion *motion, NSError *error){
            //NSLog(@"x: %f y: %f z:%f",motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
            if (motion.userAcceleration.x>self.max) {
                self.max = motion.userAcceleration.x;
                self.maxLabel.text = [NSString stringWithFormat:@"max: %f",self.max];
                self.testLabel.text =@"MAX";
            }
            
            if (motion.userAcceleration.x<self.min) {
                self.min = motion.userAcceleration.x;
                self.minLabel.text = [NSString stringWithFormat:@"min: %f",self.min];
                self.testLabel.text =@"MIN";

            }
            
            self.xmotion += motion.userAcceleration.x;
            self.ymotion += motion.userAcceleration.y;
            
            self.xLabel.text = [NSString stringWithFormat:@"x: %f",self.xmotion];
            self.yLabel.text = [NSString stringWithFormat:@"y: %f",motion.userAcceleration.y];
            self.zLabel.text = [NSString stringWithFormat:@"z: %f",motion.userAcceleration.z];
            
            
            if (self.taskIsON) {
                //Right
                if (motion.userAcceleration.x > 0.8) {
                    self.testLabel.text = @"prawo";
                    if (self.currentTask = kTask_right) {
                        
                        [self startCheckForX];
                    }
                }
                //Left
                if (motion.userAcceleration.x < (-0.8)) {
                    self.testLabel.text = @"lewo";
                    if (self.currentTask = kTask_left) {
                        
                        [self startCheckForX];
                    }
                }
                //Up
                if (motion.userAcceleration.y > 0.8) {
                     self.testLabel.text = @"gora";
                    if (self.currentTask = kTask_up) {
                       
                        [self startCheckForY];
                    }
                }
                //Down
                if (motion.userAcceleration.y < (-0.8)) {
                    self.testLabel.text = @"dol";
                    if (self.currentTask = kTask_down) {
                        
                        [self startCheckForY];
                    }
                }
            }
            
            
        }];
        
    } else {
        NSLog(@"No gyroscope on device.");
    }
}

- (void)startCheckForX
{
    self.taskIsON = NO;
    self.xmotion = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkXsum) userInfo:nil repeats:NO];
}

- (void)startCheckForY
{
    self.taskIsON = NO;
    self.ymotion = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkYsum) userInfo:nil repeats:NO];
}


- (void)checkXsum
{
    
    //self.testLabel.text = [NSString stringWithFormat:@"xmotion: %f",self.xmotion];
    NSLog(@"xmotion: %f",self.xmotion);
    [self setTaskCompleted];
}

- (void)checkYsum
{
    //self.testLabel.text = [NSString stringWithFormat:@"ymotion %f",self.ymotion];
    NSLog(@"ymotion: %f",self.ymotion);
    [self setTaskCompleted];
}

- (void)setTaskCompleted
{
    self.taskIsON = NO;
    self.arrowLabel.text = @"OK";
    [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(setTask) userInfo:nil repeats:NO];
}


- (void)scheduleNotificationWithItem
{    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [[NSDate date] addTimeInterval:5];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:@"alert body"];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)setTask
{
   // self.testLabel.text = @"...";
    NSLog(@"max :%f min:%f",self.max,self.min);
    self.min = 0;
    self.max = 0;
    
    self.currentTask = arc4random() % 4;
    switch (self.currentTask) {
        case 0:
            self.arrowLabel.text = @"prawo";
            break;
        case 1:
            self.arrowLabel.text = @"lewo";
            break;
        case 2:
            self.arrowLabel.text = @"gora";
            break;
        case 3:
            self.arrowLabel.text = @"dol";
            break;
    }
    self.taskIsON = YES;
    NSLog(@"task:%d",self.currentTask);
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
        [self setTask];
        
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

- (void)viewDidUnload {
    [self setMaxLabel:nil];
    [self setMinLabel:nil];
    [super viewDidUnload];
}
@end
