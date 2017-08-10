//
//  SearchCell.h
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/7.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - SearchCell

@class SearchCell;

@protocol SearchCellDelegate <NSObject>

@optional

- (void)searchCellDidDelete:(SearchCell *)searchCell;

@end

@interface SearchCell : UITableViewCell <SearchCellDelegate>

@property (nonatomic, weak) id <SearchCellDelegate> delegate;

- (void)loadData:(NSString *)text;

@end


#pragma mark - HotCell

@class HotCell;

@protocol HotCellDelegate <NSObject>

@optional

- (void)hotCellDidSelected:(NSUInteger)index;

@end

@interface HotCell : UITableViewCell <HotCellDelegate>

@property (nonatomic, weak) id <HotCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <UIView *> *data;

- (void)loadData:(NSMutableArray *)data;

@end


#pragma mark - SearchHeader

@interface SearchHeader : UIView

@property (nonatomic, assign) BOOL lineHiden;

- (instancetype)initWith:(NSString *)title imgStr:(NSString *)imgStr;

@end

#pragma mark - SearchFooter

@interface SearchFooter : UIView


@property (nonatomic, strong) UIButton *btnBottom;

- (instancetype)initWithTitle:(NSString *)title;

@end
