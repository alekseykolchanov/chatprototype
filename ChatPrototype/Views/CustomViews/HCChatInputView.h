//
//  HCChatInputView.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 22/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCChatInputView;


@interface HCChatInputView : UIView

@property (nonatomic) NSUInteger maxHeight;

@property (nonatomic, weak, readonly) UITextView *textView;
@property (nonatomic, weak, readonly) UIButton *sendButton;
@property (nonatomic, weak, readonly) UIButton *attachButton;

@end
