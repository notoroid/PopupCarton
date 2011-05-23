//
//  PopupCartonViewController.h
//  PopupCarton
//
//  Created by Kaname Noto on 11/05/23.
//  Copyright 2011 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PopupCartonViewController : UIViewController {
    CALayer* packageLayer_;
}

@property(nonatomic,retain) IBOutlet UIView* packageView;

- (IBAction) firedStart:(id)sender;

@end
