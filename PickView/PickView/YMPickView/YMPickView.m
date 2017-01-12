//
//  YMPickView.m
//  
//
//  Created by yons on 16/12/23.
//  Copyright © 2016年 yons. All rights reserved.
//

#import "YMPickView.h"

#define kScreenFrame                    ([UIScreen mainScreen].bounds)
#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]

BOOL isString(id obj) {
    return [obj isKindOfClass:[NSString class]];
}

BOOL isArray(id obj) {
    return [obj isKindOfClass:[NSArray class]];
}

@interface YMPickView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) BOOL           isSingleColumn;
@property (nonatomic, assign) BOOL           isDataSourceValid;

@property (nonatomic, copy  ) NSArray        *dataSource;
@property (nonatomic, copy  ) NSString       *selectedItem;         //Single Column of the selected item
@property (nonatomic, strong) NSMutableArray *selectedItems;        //Multiple Column of the selected item

@property (strong, nonatomic)  UIView *contentView;
@property (nonatomic, strong) UIPickerView   *pickerView;

@property (nonatomic, copy  ) SelectedBlock  selectedBlock;

@property (strong, nonatomic)  NSString *title;


@end

@implementation YMPickView


- (instancetype)initWithTitle:(NSString *)title DataSource:(NSArray *)dataSource withSelectedItem:(id)selectedData withSelectedBlock:(SelectedBlock)selectedBlock {
    
    self = [super initWithFrame:kScreenFrame];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGesture];
    
    if (self) {
        self.dataSource = dataSource;
        self.selectedBlock = selectedBlock;
        self.title = title;
        
        if (isString(selectedData)) {
            self.selectedItem = selectedData;
        } else if (isArray(selectedData)){
            self.selectedItems = [selectedData mutableCopy];
        }
        
        
        [self initData];
        [self setViewInterface];
        [self makePickerView];
    }
    return self;
}

#pragma mark - initData
- (void)initData {
    if (self.dataSource == nil || self.dataSource.count == 0) {
        self.isDataSourceValid = NO;
        return;
    } else {
        self.isDataSourceValid = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        static Class cls;
        if (idx == 0) {
            cls = [obj class];
            
            if (isArray(obj)) {
                weakSelf.isSingleColumn = NO;
            } else if (isString(obj)) {
                weakSelf.isSingleColumn = YES;
            } else {
                weakSelf.isDataSourceValid = NO;
                return;
            }
        } else {
            if (cls != [obj class]) {
                weakSelf.isDataSourceValid = NO;
                *stop = YES;
                return;
            }
            
            if (isArray(obj)) {
                if (((NSArray *)obj).count == 0) {
                    weakSelf.isDataSourceValid = NO;
                    *stop = YES;
                    return;
                } else {
                    for (id subObj in obj) {
                        if (!isString(subObj)) {
                            weakSelf.isDataSourceValid = NO;
                            *stop = YES;
                            return;
                        }
                    }
                }
            }
        }
    }
     ];
    
    if (self.isSingleColumn) {
        if (self.selectedItem == nil) {
            self.selectedItem = self.dataSource.firstObject;
        }
    } else {
        BOOL isSelectedItemsValid = YES;
        for (id obj in self.selectedItems) {
            if (!isString(obj)) {
                isSelectedItemsValid = NO;
                break;
            }
        }
        
        if (self.selectedItems == nil || self.selectedItems.count != self.dataSource.count || !isSelectedItemsValid) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSArray* componentItem in self.dataSource) {
                [mutableArray addObject:componentItem.firstObject];
            }
            self.selectedItems = [NSMutableArray arrayWithArray:mutableArray];
        }
    }
    
}


#pragma mark View初始配置
- (void)setViewInterface {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    [self addSubview:_contentView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];//设置背景颜色为黑色，并有0.4的透明度
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        [button setTitleColor:i == 0 ? RGB(102, 102, 102) : RGB(255, 51, 102) forState:UIControlStateNormal];
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.frame.size.width - 140, 40)];
    label.font = [UIFont systemFontOfSize:16.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(102, 102, 102);
    label.text = self.title;
    [_contentView addSubview:label];
}

- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    }else {
        if(self.selectedBlock) {
            if (self.isSingleColumn) {
                self.selectedBlock([self.selectedItem copy]);
            } else {
                self.selectedBlock([self.selectedItems copy]);
            }
        }
        [self dismiss];
    }
}

// 出现
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        _contentView.center = CGPointMake(self.frame.size.width/2, _contentView.center.y - _contentView.frame.size.height);
        
    }];
}

// 消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        _contentView.center = CGPointMake(self.frame.size.width/2, _contentView.center.y + _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark pickerView
- (void)makePickerView {
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    self.pickerView = pickerView;
    [_contentView addSubview:pickerView];
    
    if (!self.isDataSourceValid)  return;
    
    
    __weak typeof(self) weakSelf = self;
    if (self.isSingleColumn) {
        [self.dataSource enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
            if ([weakSelf.selectedItem isEqualToString:rowItem]) {
                [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
                *stop = YES;
            }
        }
         ];
    } else {
        [self.selectedItems enumerateObjectsUsingBlock:^(NSString *selectedItem, NSUInteger component, BOOL *stop) {
            [self.dataSource[component] enumerateObjectsUsingBlock:^(id rowItem, NSUInteger rowIdx, BOOL *stop) {
                if ([selectedItem isEqualToString:rowItem]) {
                    [weakSelf.pickerView selectRow:rowIdx inComponent:component animated:NO];
                    *stop = YES;
                }
            }
             ];
        }
         ];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isSingleColumn) {
        return 1;
    } else {
        return self.dataSource.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return self.dataSource.count;
    } else {
        return ((NSArray*)self.dataSource[component]).count;
    }
}

#pragma mark - UIPickerViewDelegate
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return self.dataSource[row];
    } else {
        return ((NSArray*)self.dataSource[component])[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        self.selectedItem = self.dataSource[row];
    } else {
        self.selectedItems[component] = ((NSArray*)self.dataSource[component])[row];
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:18];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    //在该代理方法里添加以下两行代码删掉上下的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    return pickerLabel;
}



@end
