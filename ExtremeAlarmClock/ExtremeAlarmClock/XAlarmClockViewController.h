//
//  XAlarmClockViewController.h
//  ExtremeAlarmClock
//
//  Created by Łukasz Czarnecki on 11/10/12.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLNumberPickerView.h"

@interface XAlarmClockViewController : UIViewController <SLNumberPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *hourCounterLabel;

@property (weak, nonatomic) IBOutlet UILabel *minuteCounterLabel;

@property (weak, nonatomic) IBOutlet UIButton *AlarmSetterButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;



@end
