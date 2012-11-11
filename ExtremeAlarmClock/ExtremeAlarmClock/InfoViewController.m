//
//  InfoViewController.m
//  ExtremeAlarmClock
//
//  Created by Miaka on 10.11.2012.
//  Copyright (c) 2012 Łukasz Czarnecki. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)closeButtonPressed:(id)sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *closeButtonImage = [UIImage imageNamed:@"../assets/close.png"];
    [self.closeButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    [self.view addSubview:self.closeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [super viewDidUnload];
}
@end
