//
//  pickerControl.h
//  F2FClient
//
//  Created by 冯凯 on 15/10/21.
//  Copyright (c) 2015年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pickerControl : UIView

/**
 *  创建pick
 *
 *  @param type    1：选择 时间； 0：选择自己的
 *  @param col     1：默认3列    0：1列
 *  @param sources nil:默认是时间  汉字传自己的数据
 *  @param block
 *
 *  @return
 */

- (instancetype)initWithType:(NSInteger)type columuns:(NSInteger)col WithDataSource:(NSArray *)sources response:(void(^)(NSString*))block;
- (void)show;
@end
