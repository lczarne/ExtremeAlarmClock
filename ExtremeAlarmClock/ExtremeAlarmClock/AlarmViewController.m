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
@property double maxX;
@property double minX;
@property double maxY;
@property double minY;
@property double distance;
@property BOOL counting;
@property int verticalMoveDirection;
@property int horizontalMoveDirection;
@property BOOL didSucced;
@property CGRect imageViewDefaultFrame;

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioPlayer *playerError;

@end

@implementation AlarmViewController

#define VERTICAL_DIR_UP 1;
#define VERTICAL_DIR_DOWN 0;
#define HORIZONTAL_DIR_RIGHT 1;
#define HORIZONTAL_DIR_LEFT 0;


- (void)startSampling
{
    self.motionManager.showsDeviceMovementDisplay = YES;
    if (self.motionManager.deviceMotionAvailable) {
        //self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        [self.motionManager startGyroUpdates];
        NSOperationQueue *operationQ = [NSOperationQueue currentQueue];
    
        
        [self.motionManager startDeviceMotionUpdatesToQueue:operationQ withHandler:^(CMDeviceMotion *motion, NSError *error){
            //NSLog(@"x: %f y: %f z:%f",motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
            if (motion.userAcceleration.x>self.maxX) {
                self.maxX = motion.userAcceleration.x;
                self.maxLabel.text = [NSString stringWithFormat:@"max: %f",self.maxX];
                self.testLabel.text =@"MAX";
                
                self.horizontalMoveDirection = HORIZONTAL_DIR_RIGHT;
            }
            
            if (motion.userAcceleration.x<self.minX) {
                self.minX = motion.userAcceleration.x;
                self.minLabel.text = [NSString stringWithFormat:@"min: %f",self.minX];
                self.testLabel.text =@"MIN";
                
                self.horizontalMoveDirection = HORIZONTAL_DIR_LEFT;

            }
            
            if (motion.userAcceleration.y>self.maxY) {
                self.maxY = motion.userAcceleration.y;
                //self.maxLabel.text = [NSString stringWithFormat:@"max: %f",self.maxX];
                self.testLabel.text =@"MAX";
                
                self.verticalMoveDirection = VERTICAL_DIR_UP;
            }
            
            if (motion.userAcceleration.y<self.minY) {
                self.minY = motion.userAcceleration.y;
                //self.minLabel.text = [NSString stringWithFormat:@"min: %f",self.minX];
                self.testLabel.text =@"MIN";
                    
                self.verticalMoveDirection = VERTICAL_DIR_DOWN;

            }
            
            self.xmotion += motion.userAcceleration.x;
            self.ymotion += motion.userAcceleration.y;
            
            self.xLabel.text = [NSString stringWithFormat:@"x: %f",self.xmotion];
            self.yLabel.text = [NSString stringWithFormat:@"y: %f",motion.userAcceleration.y];
            self.zLabel.text = [NSString stringWithFormat:@"z: %f",motion.userAcceleration.z];
            
            double limit = 1.3;
            
            if (self.taskIsON) {
                
                if (motion.userAcceleration.x > limit) {
                    
                    [self startCheckForX];

                }
                if (motion.userAcceleration.x < limit*(-1.0)) {
                    
                    [self startCheckForX];

                }
                if (motion.userAcceleration.y > limit) {
                    
                    [self startCheckForY];
                }
                if (motion.userAcceleration.y < limit*(-0.5)) {
                    
                    [self startCheckForY];
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
    
    self.maxX = 0;
    self.minX = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkXsum) userInfo:nil repeats:NO];
}

- (void)startCheckForY
{
    self.taskIsON = NO;
    self.ymotion = 0;
    
    self.maxY = 0;
    self.minY = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkYsum) userInfo:nil repeats:NO];
}


- (void)checkXsum
{
    
    //self.testLabel.text = [NSString stringWithFormat:@"xmotion: %f",self.xmotion];
    NSLog(@"xmotion: %f",self.xmotion);
    int rigthDirection = HORIZONTAL_DIR_RIGHT;
    int leftDirection = HORIZONTAL_DIR_LEFT;
    if (self.horizontalMoveDirection == rigthDirection) {
        if (self.currentTask == kTask_right) {
            self.didSucced = YES;
        }
        //self.testLabel.text = @"RIGHT";
    }
    else if (self.horizontalMoveDirection == leftDirection) {
        if (self.currentTask == kTask_left) {
            self.didSucced = YES;
        }
        //self.testLabel.text = @"LEFT";
    }
    [self setTaskCompleted];
}

- (void)checkYsum
{
    int upDirection = VERTICAL_DIR_UP;
    int downDirection = VERTICAL_DIR_DOWN;
    if (self.verticalMoveDirection == upDirection) {
        if (self.currentTask == kTask_up) {
            self.didSucced = YES;
        }
        //self.testLabel.text = @"UP";
    }
    else if (self.verticalMoveDirection == downDirection) {
        if (self.currentTask == kTask_down) {
            self.didSucced = YES;
        }
        //self.testLabel.text = @"DOWN";
    }
    //self.testLabel.text = [NSString stringWithFormat:@"ymotion %f",self.ymotion];
    NSLog(@"ymotion: %f",self.ymotion);
    [self setTaskCompleted];
}

- (void)setTaskCompleted
{
    self.taskIsON = NO;
    if (self.didSucced) {
        self.arrowLabel.text = @"OK";
        
        CGRect newArroImageViewFrame1;
        CGRect newArroImageViewFrame2;
        CGFloat positionChange1 = 30;
        CGFloat positionChange2 = 60;
        switch (self.currentTask) {
            case 0:
                newArroImageViewFrame1 = CGRectMake(self.imageViewDefaultFrame.origin.x+positionChange1, self.imageViewDefaultFrame.origin.y, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                newArroImageViewFrame2 = CGRectMake(self.imageViewDefaultFrame.origin.x-positionChange2, self.imageViewDefaultFrame.origin.y, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                
                break;
            case 1:
                newArroImageViewFrame1 = CGRectMake(self.imageViewDefaultFrame.origin.x-positionChange1, self.imageViewDefaultFrame.origin.y, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                newArroImageViewFrame2 = CGRectMake(self.imageViewDefaultFrame.origin.x+positionChange2, self.imageViewDefaultFrame.origin.y, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                break;
            case 2:
                newArroImageViewFrame1 = CGRectMake(self.imageViewDefaultFrame.origin.x, self.imageViewDefaultFrame.origin.y-positionChange1, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                newArroImageViewFrame2 = CGRectMake(self.imageViewDefaultFrame.origin.x, self.imageViewDefaultFrame.origin.y+positionChange2, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                break;
            case 3:
                newArroImageViewFrame1 = CGRectMake(self.imageViewDefaultFrame.origin.x, self.imageViewDefaultFrame.origin.y+positionChange1, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                newArroImageViewFrame2 = CGRectMake(self.imageViewDefaultFrame.origin.x, self.imageViewDefaultFrame.origin.y-positionChange2, self.imageViewDefaultFrame.size.width, self.imageViewDefaultFrame.size.height);
                break;
        }
        
        [self playSound];
        
        [UIView animateWithDuration:0.05 animations:^{
            self.arrowImageView.frame = newArroImageViewFrame1;
        }
                         completion:^(BOOL succes){
                             [UIView animateWithDuration:0.2 animations:^{
                                 self.arrowImageView.frame = newArroImageViewFrame2;
                                 self.arrowImageView.alpha = 0;
                             }];
                         }
         ];
        
        self.resultColorView.backgroundColor = [UIColor greenColor];
        [UIView animateWithDuration:0.1 animations:^{
            self.resultColorView.alpha = 0.4;
            
        } completion:^(BOOL succes){
            [UIView animateWithDuration:0.3 animations:^{
                self.resultColorView.alpha = 0;
            }];
        }];
        
    }
    else{
        self.arrowLabel.text = @"FAIL";
        [self playErrorSound];
        [UIView animateWithDuration:0.7 animations:^{
            self.arrowImageView.alpha = 0;
        }];
        
        self.resultColorView.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:0.1 animations:^{
            self.resultColorView.alpha = 0.4;
            
        } completion:^(BOOL succes){
            [UIView animateWithDuration:0.3 animations:^{
                self.resultColorView.alpha = 0;
            }];
        }];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTask) userInfo:nil repeats:NO];
    
   
    

}

- (void)playSound
{
//    dispatch_queue_t myCustomQueue;
//    myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
//    
//    dispatch_async(myCustomQueue, ^{
        [self.player stop];
        self.player.currentTime = 0;
        [self.player play];
//        NSLog(@"Do some work here.\n");
//    });
}

- (void)playErrorSound
{
    //    dispatch_queue_t myCustomQueue;
    //    myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
    //
    //    dispatch_async(myCustomQueue, ^{
    [self.playerError stop];
    self.playerError.currentTime = 0;
    [self.playerError play];
    //        NSLog(@"Do some work here.\n");
    //    });
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

    if (!self.taskIsON) {
        
        
        NSLog(@"max :%f min:%f",self.maxX,self.minX);
        self.maxX = 0;
        self.minX = 0;
        
        self.maxY = 0;
        self.minY = 0;
        self.didSucced = NO;
        
        self.currentTask = arc4random() % 4;
        switch (self.currentTask) {
            case 0:
                self.arrowImageView.image = [UIImage imageNamed:@"right.png"];
                self.arrowLabel.text = @"prawo";
                break;
            case 1:
                self.arrowImageView.image = [UIImage imageNamed:@"left.png"];
                self.arrowLabel.text = @"lewo";
                break;
            case 2:
                self.arrowImageView.image = [UIImage imageNamed:@"up.png"];
                self.arrowLabel.text = @"gora";
                break;
            case 3:
                self.arrowImageView.image = [UIImage imageNamed:@"down.png"];
                self.arrowLabel.text = @"dol";
                break;
        }
        self.arrowImageView.frame = self.imageViewDefaultFrame;
        [UIView animateWithDuration:0.1 animations:^{
            self.arrowImageView.alpha = 1.0;
        }];
        self.taskIsON = YES;
        NSLog(@"task:%d",self.currentTask);
    }
    
}

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupPlayers
{
    NSURL* musicFileDing = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"ding3"
                                               ofType:@"wav"]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFileDing error:nil];
    [self.player prepareToPlay];
    [self.player setVolume: 1.0];
    [self.player setDelegate:self];
    
    NSURL* musicFileError = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"error2"
                                               ofType:@"wav"]];
    
    self.playerError = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFileError error:nil];
    [self.playerError prepareToPlay];
    [self.playerError setVolume: 1.0];
    [self.playerError setDelegate:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPlayers];
    
    self.resultColorView.alpha = 0;
    self.taskIsON = NO;
    self.arrowImageView.alpha = 0;
    self.imageViewDefaultFrame = self.arrowImageView.frame;
        
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
    [self setArrowImageView:nil];
    [self setResultColorView:nil];
    [super viewDidUnload];
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) completed {
    
    if (completed == YES) {
        
    }
}
@end
