//
//  HCChatInputView.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 22/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCChatInputView.h"

@interface HCChatInputView ()

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

@end

@implementation HCChatInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildSubviews];
        [self subscribeToNotifications];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self buildSubviews];
        [self subscribeToNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildSubviews {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:textView];
    [self setTextView: textView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [sendButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [sendButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [[sendButton titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
    [self addSubview:sendButton];
    [self setSendButton:sendButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[textView]-(2)-[sendButton]-(2)-|" options:0 metrics:nil views:@{@"textView" : textView, @"sendButton" : sendButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(6)-[textView]-(6)-|" options:0 metrics:nil views:@{@"textView" : textView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sendButton(==44)]-(0)-|" options:0 metrics:nil views:@{@"sendButton" : sendButton}]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateHeightConstraint];
}

- (NSLayoutConstraint *) heightConstraint {
    if (!_heightConstraint) {
        [self assignHeightConstraint];
    }
    
    return _heightConstraint;
}

- (void)assignHeightConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.firstItem == self) {
            
            if (constraint.relation == NSLayoutRelationEqual) {
                self.heightConstraint = constraint;
            }
            
        }
    }
    
    if (!_heightConstraint) {
        for (NSLayoutConstraint *constraint in self.superview.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.firstItem == self) {
                
                if (constraint.relation == NSLayoutRelationEqual) {
                    self.heightConstraint = constraint;
                }
                
            }
        }
    }
}

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:[self textView]];
}

- (void)updateHeightConstraint {
    CGSize sizeToFit = [[self textView] sizeThatFits:[self textView].frame.size];
    
    CGFloat newSize = sizeToFit.height + 12.0;
    if ([self maxHeight] > 0 && [self maxHeight] < newSize) {
        newSize = [self maxHeight];
        [[self textView] setScrollEnabled:YES];
    }else{
        [[self textView] setScrollEnabled:NO];
    }
    
    [[self heightConstraint] setConstant:newSize];
}

- (void)textViewDidChange:(NSNotification *)notification {
    
    [self updateHeightConstraint];
}


@end
