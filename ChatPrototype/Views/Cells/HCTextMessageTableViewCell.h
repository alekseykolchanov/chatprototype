//
//  HCTextMessageTableViewCell.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCBaseMessageTableViewCell.h"

@interface HCTextMessageTableViewCell : HCBaseMessageTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
