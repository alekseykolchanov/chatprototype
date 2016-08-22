//
//  HCBaseMessageTableViewCell.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBaseMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *tappableView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;

@end
