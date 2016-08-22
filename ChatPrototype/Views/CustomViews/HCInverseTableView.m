//
//  HCInverseTableView.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 22/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCInverseTableView.h"

@implementation HCInverseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.transform = CGAffineTransformMakeScale(1,-1);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.transform = CGAffineTransformMakeScale(1,-1);
    }
    
    return self;
}

void swapCGFLoat(CGFloat *a, CGFloat *b) {
    CGFloat tmp = *a;
    *a = *b;
    *b = tmp;
}

- (UIEdgeInsets)contentInset {
    UIEdgeInsets insets = [super contentInset];
    swapCGFLoat(&insets.top, &insets.bottom);
    return insets;
}
- (void)setContentInset:(UIEdgeInsets)contentInset {
    swapCGFLoat(&contentInset.top, &contentInset.bottom);
    [super setContentInset:contentInset];
}

@end
