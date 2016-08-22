//
//  BaseMessage.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "BaseMessage.h"
#import "User.h"

@implementation BaseMessage

@dynamic messageStatus;

- (HCMessageStatus)messageStatus {
    if (![self status]) {
        return HCMessageStatusUnknown;
    }
    
    return [[self status] unsignedIntegerValue];
}

- (void)setMessageStatus:(HCMessageStatus)messageStatus {
    if (messageStatus == HCMessageStatusUnknown) {
        [self setStatus:nil];
    }else{
        [self setStatus:@(messageStatus)];
    }
}

// Insert code here to add functionality to your managed object subclass

@end
