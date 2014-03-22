//
//  PostToBloggerViewController.h
//  SST Lens
//
//  Created by Pan Ziyue on 17/3/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostToBloggerViewController : UITableViewController
{
    IBOutlet UITextField *title;
    IBOutlet UITextView *content;
}

@property (strong, nonatomic) IBOutlet UITextField *title;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) NSObject *activity;

-(IBAction)postToBlogger:(id)sender;
-(IBAction)exit:(id)sender;

@end
