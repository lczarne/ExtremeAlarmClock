//
//  XAlarmClockViewController.h
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAlarmClockViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hourCounterLabel;

@property (weak, nonatomic) IBOutlet UILabel *minuteCounterLabel;

@property (weak, nonatomic) IBOutlet UIButton *AlarmSetterButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end
