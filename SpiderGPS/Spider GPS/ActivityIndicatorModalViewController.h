//
//  ActivityIndicatorModalViewController.h
//
//  Created by Chad Berkley on 6/20/11.
//

#import <UIKit/UIKit.h>


@interface ActivityIndicatorModalViewController : UIViewController {
    
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *smallView;
    IBOutlet UIProgressView *progressBar;
    UILabel *descriptionLabel;
    UIView *containerView;
}

@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *smallView;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

- (void)updateProgressBar:(CGFloat)value;
- (void)useProgressBar;
- (void)changeProgressBar:(NSString*)strVal;

@end
