//
//  lycStripModel.h
//  blogapp
//
//  Created by aotuman on 13-11-6.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lycStripModel : NSObject

//标题
@property (strong,nonatomic) NSString *title;
//简述
@property (strong,nonatomic) NSString *desc;
//图片
@property (strong,nonatomic) UIImage *img;

-(id)initWithTitle:(NSString *)newTitle andDesc:(NSString *)newDesc andPic:(NSString *)newImg;
@end
