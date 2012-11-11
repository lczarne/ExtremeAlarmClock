//
//  AlarmViewController.h
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVAudioPlayer.h>


@interface AlarmViewController : UIViewController <AVAudioPlayerDelegate>
@property (nonatomic, strong) CMMotionManager *motionManager;
@property int currentTask;
@property BOOL taskIsON;
@property double xmotion;
@property double ymotion;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property (weak, nonatomic) IBOutlet UIView *resultColorView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
