//
//  YMPickView.h
//  
//
//  Created by yons on 16/12/23.
//  Copyright © 2016年 yons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedBlock) (id item);

@interface YMPickView : UIView

/**
 点击阴影是否移除PickerView。默认NO
 */
@property(nonatomic,assign)BOOL shouldDismissWhenClickShadow;

/**
 创建数组数据源PickerView
 
 @param dataSource 数组数据源
 @param selectedData 默认选中的行(可传数组)
 @param selectedBlock 选择后的回调
 @return 实例
 */
- (instancetype)initWithTitle:(NSString *)title
                    DataSource:(NSArray *)dataSource
                  withSelectedItem:(nullable id)selectedData
                 withSelectedBlock:(SelectedBlock)selectedBlock;

- (void)show;

@end


NS_ASSUME_NONNULL_END
