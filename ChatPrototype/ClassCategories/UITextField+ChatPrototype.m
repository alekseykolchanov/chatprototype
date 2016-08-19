//
//  UITextField+ChatPrototype.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "UITextField+ChatPrototype.h"

@implementation UITextField (ChatPrototype)

- (NSString *)cleanText {
    return [[self text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
