//
//  HCLoginViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCLoginViewController.h"
#import "UITextField+ChatPrototype.h"
#import "HCLoginViewModel.h"

const float HCDistanceFromKeyboardToCentralView = 10.0;

@interface HCLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) id<HCLoginViewModelProtocol> viewModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:[self nameTextField]];
    
    
    [[self nameTextField] setDelegate: self];
    
    [self setupViewModel];
    
    [self setupViewsAppearance];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateStartButtonState];
    [[self nameTextField] becomeFirstResponder];
}

- (void)setupViewModel {
    id<HCLoginViewModelProtocol> viewModel = [[HCLoginViewModel alloc] init];
    [self setViewModel: viewModel];
}

- (void)tryToLogin {
    NSString *enteredName = [[self nameTextField] cleanText];
    if ([[self viewModel] isLoginPossibleWithName: enteredName]) {
        
        [[self activityIndicator] startAnimating];
        [[self nameTextField] setEnabled:false];
        [[self nameTextField] resignFirstResponder];
        [[self viewModel] loginWithName:[[self nameTextField] cleanText] completion:^(BOOL isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    
                }
                
                [[self activityIndicator] stopAnimating];
                [[self nameTextField] setEnabled:true];
            });
        }];
        
    }
}

#pragma mark - IBActions
- (IBAction)startButtonTapped:(id)sender {
    [self tryToLogin];
}

#pragma mark - Views setup
- (void)setupViewsAppearance {
    
    UIEdgeInsets contentInset = [[self scrollView] contentInset];
    contentInset.top = [self topLayoutGuide].length + 90;
    [[self scrollView] setContentInset: contentInset];
    
    [self centerView].layer.shadowColor = [UIColor blackColor].CGColor;
    [self centerView].layer.shadowOffset = CGSizeMake(6, 6);
    [self centerView].layer.shadowRadius = 1.0;
    [self centerView].layer.shadowOpacity = 0.5;
}

- (void)updateStartButtonState {

    [[self startButton] setEnabled:[[self nameTextField] isEnabled] && [[self viewModel] isLoginPossibleWithName: [[self nameTextField] cleanText]]];

}


#pragma mark - UITextFieldDelegate
- (void)textFieldTextDidChange:(NSNotification *)notification {
    [self updateStartButtonState];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tryToLogin];
    return YES;
}
#pragma mark - KeyboardNotifications
- (void)scrollToShowCentralView {
    CGRect rectToShow = [self scrollViewContentView].frame;
    rectToShow.origin.y += HCDistanceFromKeyboardToCentralView ;
    rectToShow.size.height -= HCDistanceFromKeyboardToCentralView;
    [[self scrollView] scrollRectToVisible:rectToShow animated:YES];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect keyboardRect = [((NSValue *)[notification userInfo][UIKeyboardFrameEndUserInfoKey]) CGRectValue];
    float keyboardHeight = [self.view.window convertRect:keyboardRect toView:self.view].size.height;
    
    float duration = ((NSNumber *)[notification userInfo][UIKeyboardAnimationDurationUserInfoKey]).floatValue;
    NSUInteger animationCurveOptions = ((NSNumber *)[notification userInfo][UIKeyboardAnimationCurveUserInfoKey]).unsignedIntegerValue;
    
    UIEdgeInsets insets = [[self scrollView] contentInset];
    insets.bottom = keyboardHeight + HCDistanceFromKeyboardToCentralView;
    
    [UIView animateWithDuration:duration delay:0 options:animationCurveOptions animations:^{
        [[self scrollView] setContentInset:insets];
    } completion:^(BOOL finished) {
        if (finished) {
            [self scrollToShowCentralView];
        }
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    float duration = ((NSNumber *)[notification userInfo][UIKeyboardAnimationDurationUserInfoKey]).floatValue;
    NSUInteger animationCurveOptions = ((NSNumber *)[notification userInfo][UIKeyboardAnimationCurveUserInfoKey]).unsignedIntegerValue;
    
    UIEdgeInsets insets = [[self scrollView] contentInset];
    insets.bottom = 0.0;
    
    [UIView animateWithDuration:duration delay:0 options:animationCurveOptions animations:^{
        [[self scrollView] setContentInset:insets];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    
    CGRect keyboardRect = [((NSValue *)[notification userInfo][UIKeyboardFrameEndUserInfoKey]) CGRectValue];
    float keyboardHeight = [self.view.window convertRect:keyboardRect toView:self.view].size.height;
    
    
    
    UIEdgeInsets insets = [[self scrollView] contentInset];
    insets.bottom = keyboardHeight + HCDistanceFromKeyboardToCentralView;
    
    [UIView animateWithDuration:0.1 animations:^{
        [[self scrollView] setContentInset:insets];
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
