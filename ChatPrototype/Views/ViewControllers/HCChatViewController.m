//
//  HCChatViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCChatViewController.h"
#import "HCChatViewModel.h"
#import "HCDateTimeTableViewCell.h"
#import "HCTextMessageTableViewCell.h"
#import "HCChatInputView.h"
#import "HCSelectMapViewController.h"

NSString * const HCChatDateTimeTableViewCellIdentifier = @"HCDateTimeTableViewCell";
NSString * const HCChatRecievedTextMessageTableViewCellIdentifier = @"HCRecievedTextMessageTableViewCell";
NSString * const HCChatSentTextMessageTableViewCellIdentifier =@"HCSentTextMessageTableViewCell";
NSString * const HCChatRecievedImageMessageTableViewCellIdentifier = @"HCRecievedImageMessageTableViewCell";
NSString * const HCChatSentImageMessageTableViewCellIdentifier =@"HCSentImageMessageTableViewCell";

NSString * const HCChatSelectGPSSegueIdentifier = @"HCChatSelectGPSSegue";
NSString * const HCChatShowGPSOnMapSegueIdentifier = @"HCShowMapSegue";

@interface HCChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, HCSelectMapViewControllerDelegate, HCMessageCellDelegate>

@property (nonatomic, strong) id<HCChatViewModelProtocol> viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HCChatInputView *chatInputView;

@property (nonatomic, strong, readonly) UIImage *sentBubbleImage;
@property (nonatomic, strong, readonly) UIImage *receivedBubbleImage;


@end


@implementation HCChatViewController
@synthesize sentBubbleImage = _sentBubbleImage;
@synthesize receivedBubbleImage = _receivedBubbleImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[[weakSelf chatInputView] textView] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    }];
    
    
    [self.chatInputView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
         NSNumber *options = note.userInfo[UIKeyboardAnimationCurveUserInfoKey];
         CGRect beginFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
         
         CGRect keyboardBeginFrame = [weakSelf.view.window convertRect:beginFrame toView:self.view];
         CGRect keyboardEndFrame = [weakSelf.view.window convertRect:endFrame toView:self.view];
         
         UIEdgeInsets newEdgeInsets = weakSelf.tableView.contentInset;
         newEdgeInsets.bottom = weakSelf.view.bounds.size.height - keyboardEndFrame.origin.y;
         CGPoint newContentOffset = weakSelf.tableView.contentOffset;
         newContentOffset.y += keyboardEndFrame.origin.y - keyboardBeginFrame.origin.y;
         
         [UIView animateWithDuration:duration.doubleValue
                               delay:0.0
                             options:options.integerValue
                          animations:^{
                              weakSelf.tableView.contentInset = newEdgeInsets;
                              weakSelf.tableView.scrollIndicatorInsets = newEdgeInsets;
                              weakSelf.tableView.contentOffset = newContentOffset;
                              
                          } completion:^(BOOL finished) {
                    
                          }];
     }];
    
    [[[self chatInputView] textView] setDelegate:self];
    
    
    
    [self setupViewModel];
    [self setupViewsAppearance];
    
    [[[self chatInputView] attachButton] addTarget:self action:@selector(attachButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [[[self chatInputView] sendButton] addTarget:self action:@selector(sendButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self viewModel] reloadItemsCollection];
}

- (UIView *)inputAccessoryView {
    return [self chatInputView];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setupViewModel {
    HCChatViewModel *viewModel = [[HCChatViewModel alloc]initWithFriendGuid:[self friendGuid]];
    
    NSAssert(viewModel != nil, @"Wasn't able to instantiate HCChatViewModel");
    
    [self setViewModel:viewModel];
    
    __weak typeof(self) weakSelf = self;
    [viewModel setItemsCollectionDidChangeBlock:^{
            [[weakSelf tableView] reloadData];
    }];
    
    [viewModel setItemsCollectionDidUpdateItemsBlock:^(NSArray *updatedIndexPaths){
        if (!updatedIndexPaths || [updatedIndexPaths count] == 0)
            return;
        [[weakSelf tableView] reloadRowsAtIndexPaths:updatedIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    [viewModel setItemsCollectionDidAddItemsBlock:^(NSArray *insertedIndexPaths){
        if (!insertedIndexPaths || [insertedIndexPaths count] ==0)
            return;
        
        [[weakSelf tableView] insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        
    }];
    
    [viewModel setItemsCollectionStartUpdateItemsBlock:^{
        [[weakSelf tableView] beginUpdates];
    }];
    
    [viewModel setItemsCollectionFinishUpdateItemsBlock:^{
        [[weakSelf tableView] endUpdates];
    }];
}

- (UIImage *)sentBubbleImage {
    if (!_sentBubbleImage) {
        _sentBubbleImage = [[UIImage imageNamed:@"SentBubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18) resizingMode:UIImageResizingModeStretch];
    }
    
    return _sentBubbleImage;
}

- (UIImage *)receivedBubbleImage {
    if (!_receivedBubbleImage){
        _receivedBubbleImage = [[UIImage imageNamed:@"RecievedBubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18) resizingMode:UIImageResizingModeStretch];
    }
    
    return _receivedBubbleImage;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:HCChatSelectGPSSegueIdentifier]) {
        UINavigationController *navVC = [segue destinationViewController];
        HCSelectMapViewController *mapViewController = [navVC viewControllers][0];
        [mapViewController setDelegate:self];
    }
    
}

#pragma mark - Views setup
- (void)setupViewsAppearance {
    
    [[self navigationItem] setTitle:[[self viewModel] chatFriendName]];
    
    [[self chatInputView] setTintColor:[self.view tintColor]];
    [[self chatInputView] setMaxHeight:100.0f];
    [[[self chatInputView] textView] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    [self chatInputView].layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self chatInputView].layer.borderWidth = 0.5f;
    [self chatInputView].textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self chatInputView].textView.layer.borderWidth = 0.5f;
    [[[self chatInputView] sendButton] setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self updateSendButtonState];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [[self tableView]setTableHeaderView:headerView];
    
}

- (void)updateSendButtonState {
    if ([[self viewModel] isTextMessagePossibleWithText:[[[self chatInputView] textView] text]]) {
        [[[self chatInputView] sendButton] setEnabled:YES];
    }else{
        [[[self chatInputView] sendButton] setEnabled:NO];
    }
}

#pragma mark - Actions
-(void)sendButtonDidTap:(id)sender {
    if ([[self viewModel] isTextMessagePossibleWithText:[[[self chatInputView] textView] text]]) {
        [[self viewModel] sendMessageWithText:[[[self chatInputView] textView] text] completion:^(BOOL isSuccess) {
            
        }];
        [[[self chatInputView] textView] setText:@""];
        [self updateSendButtonState];
    }else{
        [[[self chatInputView] sendButton] setEnabled:NO];
    }
}

-(void)attachButtonDidTap:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *gpsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share location", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            
        }];
        [weakSelf performSegueWithIdentifier:HCChatSelectGPSSegueIdentifier sender:weakSelf];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [ac addAction:gpsAction];
    [ac addAction:cancelAction];
    
    [[[self chatInputView] textView] resignFirstResponder];
    [self presentViewController:ac animated:YES completion:nil];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self viewModel] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self viewModel] numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCChatEntityType entityType = [[self viewModel] typeOfItemAtIndexPath: indexPath];
    
    switch (entityType) {
        case HCChatEntityTypeDateString: {
            HCDateTimeTableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:HCChatDateTimeTableViewCellIdentifier];
            HCChatDateStringEntity *dateEntity = [[self viewModel] itemAtIndexPath:indexPath];
            [[cell dateTimeLabel] setText:[dateEntity dateTimeString]];
            return cell;
        }
        case HCChatEntityTypeTextMessageSent:{
            HCTextMessageTableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:HCChatSentTextMessageTableViewCellIdentifier];
            HCTextMessageEntity *messageEntity = [[self viewModel] itemAtIndexPath:indexPath];
            [cell setMessageGuid:[messageEntity guid]];
            [[cell messageLabel] setText:[messageEntity text]];
            [[cell bubbleImageView] setImage:[self sentBubbleImage]];
            return cell;
        }
        case HCChatEntityTypeTextMessageRecieved:{
            HCTextMessageTableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:HCChatRecievedTextMessageTableViewCellIdentifier];
            HCTextMessageEntity *messageEntity = [[self viewModel] itemAtIndexPath:indexPath];
            [cell setMessageGuid:[messageEntity guid]];
            [[cell messageLabel] setText:[messageEntity text]];
            [[cell bubbleImageView] setImage:[self receivedBubbleImage]];
            return cell;
        }
        case HCChatEntityTypeImageMessageSent:{
            
            break;
        }
        case HCChatEntityTypeImageMessageRecieved:{
            
            break;
        }
        case HCChatEntityTypeGPSMessageSent:{
            
            break;
        }
        case HCChatEntityTypeGPSMessageRecieved:{
            
            break;
        }
        default:
            break;
    }
    
    NSAssert(false, @"Message entity wasn't identified");
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updateSendButtonState];
}

#pragma mark - HCSelectMapViewControllerDelegate 
- (void)selectMapViewController:(HCSelectMapViewController *)mapViewController wantsToCloseWithResult:(NSDictionary *)resultDictionary {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - HCMessageCellDelegate 
- (void)messageCellDidTap:(HCBaseMessageTableViewCell *)cell {
    NSString *messageGuid = [cell messageGuid];
    
    if (!messageGuid)
        return;
    
    NSString *reuseIdentifier = [cell reuseIdentifier];
    
    if ([reuseIdentifier isEqualToString:HCChatRecievedImageMessageTableViewCellIdentifier] ||
        [reuseIdentifier isEqualToString:HCChatSentImageMessageTableViewCellIdentifier]) {
        
    }
}

@end
