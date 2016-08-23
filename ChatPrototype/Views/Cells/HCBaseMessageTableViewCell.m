//
//  HCBaseMessageTableViewCell.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCBaseMessageTableViewCell.h"

@interface HCBaseMessageTableViewCell()

@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation HCBaseMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.transform = CGAffineTransformMakeScale(1,-1);
    self.accessoryView.transform = CGAffineTransformMakeScale(1,-1);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerDidTap:)];
    [[self tappableView] addGestureRecognizer:tapRecognizer];
    [self setTapGestureRecognizer:tapRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapRecognizerDidTap:(id)sender {
    [[self delegate] messageCellDidTap:self];
}

@end
