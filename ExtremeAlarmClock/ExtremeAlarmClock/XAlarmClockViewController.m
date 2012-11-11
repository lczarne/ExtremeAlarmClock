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

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    // set the alarm clock to the chosen number
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hour = [dateFormatter stringFromDate:currentDateTime];
    [dateFormatter setDateFormat:@"mm"];
    NSString *minute = [dateFormatter stringFromDate:currentDateTime];
    self.hourCounterLabel.text = [NSString stringWithFormat:@"%@",hour];
    self.minuteCounterLabel.text = [NSString stringWithFormat:@"%@",minute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
