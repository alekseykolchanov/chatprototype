//
//  HCDateTimeTableViewCell.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCDateTimeTableViewCell.h"

@implementation HCDateTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.transform = CGAffineTransformMakeScale(1,-1);
    self.accessoryView.transform = CGAffineTransformMakeScale(1,-1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
