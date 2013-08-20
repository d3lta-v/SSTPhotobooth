//
//  PhotoboothViewController2.h
//  SST Photobooth
//
//  Created by Pan Ziyue on 4/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoboothViewController2 : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIImagePickerController *controller;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    UIImage *imageChoosed;
}


@property (nonatomic) bool showEditorOrController;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *watermark;

@property (strong, nonatomic) UIImage *imageChoosed;

-(IBAction)pencilPressed:(id)sender;

//-(IBAction)shareButton:(id)sender;
-(IBAction)shareActivityButton:(id)sender;

-(IBAction)save:(id)sender;
-(IBAction)reset:(id)sender;

-(IBAction)filterSelector:(id)sender;
-(IBAction)watermarkSelector:(id)sender;

@end
