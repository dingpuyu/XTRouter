//
//  XTRouter.h
//  5i5jAPP
//
//  Created by 丁璞玉 on 2017/11/23.
//  Copyright © 2017年 NiLaisong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XTRouter : NSObject

+ (instancetype)shareInstance;

/*
    根据schema获取控制器，可能为空
**/
- (UIViewController*)controllerWithSchema:(NSString*)schema;

/**
    根据有schema的域名获取schema参数
 **/
- (NSString*)handleSchemaHTMLPathWith:(NSURL*)webURL;

/**
   根据网页路径获取schema
 **/
- (NSString*)handleHTMLPathWith:(NSURL*)webURL;

@end
