//
//  lycStripModel.m
//  blogapp
//
//  Created by aotuman on 13-11-6.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycStripModel.h"

@implementation lycStripModel

-(id)initWithTitle:(NSString *)newTitle andDesc:(NSString *)newDesc andPic:(NSString *)newImg{
    self=[super init];
    if (self) {
        _title=newTitle;
        _desc=newDesc;
        //兼容http
        if ([newImg rangeOfString:@"http://"].length) {
              _img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newImg]]];
        }else{
         _img=[UIImage imageNamed:newImg];
        }
    }
    return self;
}
@end
