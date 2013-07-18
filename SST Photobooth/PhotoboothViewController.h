//
//  PhotoboothViewController.h
//  SST Photobooth
//
//  Created by Pan Ziyue on 2/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoboothViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate, UIActionSheetDelegate>
{
    UIImagePickerController *controller;
}

-(IBAction)editorPressed:(id)sender;
-(IBAction)newPressed:(id)sender;
-(IBAction)sharePressed:(id)sender;

@end
