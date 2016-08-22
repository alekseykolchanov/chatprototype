//
//  HCModelSupport.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HCMessageStatus) {
    HCMessageStatusUnknown = 0,
    HCMessageStatusCreated,
    HCMessageStatusSentToServer,
    HCMessageStatusRecieved,
    HCMessageStatusRead,
};

@interface HCModelSupport : NSObject

@end
