//
//  HCBaseMessageTableViewCell.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCBaseMessageTableViewCell;


@protocol HCMessageCellDelegate <NSObject>

- (void)messageCellDidTap:(HCBaseMessageTableViewCell *)cell;

@end


@interface HCBaseMessageTableViewCell : UITableViewCell


@property (nonatomic, strong) NSString *messageGuid;


@property (nonatomic, weak) id<HCMessageCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *tappableView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;

@end
