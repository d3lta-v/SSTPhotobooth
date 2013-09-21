//
//  LensAboutViewController.m
//  SST Lens
//
//  Created by Pan Ziyue on 26/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "LensAboutViewController.h"

@interface LensAboutViewController ()

@end

@implementation LensAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)feedback:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/sst-lens/id681870976?ls=1&mt=8"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
