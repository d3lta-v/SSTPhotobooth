//
//  PhotoboothViewController2.h
//  SST Photobooth
//
//  Created by Pan Ziyue on 4/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoboothViewController2 : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    UIImagePickerController *controller;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    bool potraitOrLandscape;
    
    UIImage *imageChoosed;
}


@property (nonatomic) bool showEditorOrController;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *watermark;
@property (strong, nonatomic) IBOutlet UISlider *brushSizeSlider;

@property (strong, nonatomic) UIImage *imageChoosed;
@property (nonatomic) bool potraitOrLandscape;

@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *watermarkButton;

-(IBAction)pencilPressed:(id)sender;
-(IBAction)brushSizeChanged:(id)sender;

-(IBAction)shareActivityButton:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)reset:(id)sender;
-(IBAction)goBack:(id)sender;

-(IBAction)filterSelector:(id)sender;
-(IBAction)watermarkSelector:(id)sender;

@end
