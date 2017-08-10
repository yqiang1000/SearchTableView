//
//  SearchTableView.m
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/8.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import "SearchTableView.h"
#import "SearchCell.h"

@interface SearchTableView () <UITableViewDelegate, UITableViewDataSource, HotCellDelegate, SearchCellDelegate>


@end

@implementation SearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *searchList = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
    if (searchList.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *searchList = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
    if (section == 0) {
        return 1;
    } else {
        return searchList.count;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableViewDidScroll:)]) {
        [_searchTableViewDelegate searchTableViewDidScroll:self];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier1 = @"hotCell";
        HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.delegate = self;
        }
        [cell loadData:self.hotData];
        return cell;
    } else {
        static NSString *identifier = @"searchCell";
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        NSMutableArray *searchList = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
        [cell loadData:searchList[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
        if (indexPath.row < arr.count) {
            _searchKey = arr[indexPath.row];
            
            if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableView:didSelectedHistory:index:)]) {
                [_searchTableViewDelegate searchTableView:self didSelectedHistory:_searchKey index:indexPath.row];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        SearchHeader *header = [[SearchHeader alloc] initWith:@"热门标签" imgStr:@"搜索-phone-热门标签"];
        header.lineHiden = YES;
        return header;
    } else if (section == 1) {
        SearchHeader *header = [[SearchHeader alloc] initWith:@"最近搜索" imgStr:@"搜索-phone-历史记录"];
        header.lineHiden = NO;
        return header;
    } else return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        return view;
    } else {
        SearchFooter *footer = [[SearchFooter alloc] initWithTitle:@"清除历史记录"];
        [footer.btnBottom addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    }
}

#pragma mark - HotCellDelegate

- (void)hotCellDidSelected:(NSUInteger)index {
    if (index < self.hotData.count) {
        _searchKey = self.hotData[index];
        if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableView:didSelectedHot:index:)]) {
            [_searchTableViewDelegate searchTableView:self didSelectedHot:_searchKey index:index];
        }
    }
}

#pragma mark - SearchCellDelegate

- (void)searchCellDidDelete:(SearchCell *)searchCell {
    NSIndexPath *indexPath = [self indexPathForCell:searchCell];
    [self deleteHistoryByIndex:indexPath.row];
}

#pragma mark - publick

/** 热门搜索 */
- (void)setHotData:(NSMutableArray<NSString *> *)hotData {
    if (hotData) {
        _hotData = hotData;
        [self reloadData];
    }
}

/** 插入搜索记录 */
- (void)insertSearchKey:(NSString *)searchKey {
    
    _searchKey = searchKey;
    
    if (searchKey == nil || searchKey.length == 0) {
        return;
    }
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
    if (array.count > 10) {
        array = [array subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:array];
    if (searchList == nil) {
        searchList = [[NSMutableArray alloc] init];
    }
    __block BOOL isHas = NO;
    __block NSInteger index = 0;
    
    [searchList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:searchKey]) {
            isHas = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (isHas) {
        [searchList removeObjectAtIndex:index];
    }
    
    [searchList insertObject:STRING(searchKey) atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:SEARCH_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 根据关键字删除搜索记录 */
- (void)deleteHistoryBySearchKey:(NSString *)searchKey {
    
    _searchKey = searchKey;
    
    if (_searchKey == nil || _searchKey.length == 0) {
        return;
    }
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST];
    if (array.count > 10) {
        array = [array subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:array];
    if (searchList == nil) {
        searchList = [[NSMutableArray alloc] init];
    }
    __block BOOL isHas = NO;
    __block NSInteger index = 0;
    
    [searchList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:searchKey]) {
            isHas = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (isHas) {
        [searchList removeObjectAtIndex:index];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:SEARCH_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 根据索引删除搜索记录 */
- (void)deleteHistoryByIndex:(NSInteger)index {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_LIST]];
    if (index < array.count) {
        [array removeObjectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:SEARCH_LIST];
        [self reloadData];
    }
}

/** 清除所有记录 */
- (void)deleteHistory {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCH_LIST];
    [self reloadData];
}

@end
