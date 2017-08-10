//
//  SearchTableView.h
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/8.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTableView;

@protocol SearchTableViewDelegate <NSObject>

@optional

/** 点击热门 */
- (void)searchTableView:(SearchTableView *)tableView didSelectedHot:(NSString *)hotStr index:(NSInteger)index;

/** 点击记录 */
- (void)searchTableView:(SearchTableView *)tableView didSelectedHistory:(NSString *)historyStr index:(NSInteger)index;

/** 滑动事件（隐藏键盘） */
- (void)searchTableViewDidScroll:(SearchTableView *)tableView;

@end

@interface SearchTableView : UITableView <SearchTableViewDelegate>

/** 代理 */
@property (nonatomic, weak) id <SearchTableViewDelegate> searchTableViewDelegate;

/** 热门搜索 */
@property (nonatomic, strong) NSMutableArray <NSString *> *hotData;

/** 搜索关键字 */
@property (nonatomic, copy) NSString *searchKey;

/** 插入搜索记录 */
- (void)insertSearchKey:(NSString *)searchKey;

/** 根据关键字删除搜索记录 */
- (void)deleteHistoryBySearchKey:(NSString *)searchKey;

/** 根据索引删除搜索记录 */
- (void)deleteHistoryByIndex:(NSInteger)index;

/** 清除所有记录 */
- (void)deleteHistory;

@end
