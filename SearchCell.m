//
//  SearchCell.m
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/7.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import "SearchCell.h"
#import <TTGTagCollectionView/TTGTagCollectionView.h>

#pragma mark - SearchCell

@interface SearchCell ()

@property (nonatomic, strong) UILabel *labTxt;

@property (nonatomic, strong) UIButton *btnDele;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B9;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUI {
    [self.contentView addSubview:self.labTxt];
    [self.contentView addSubview:self.btnDele];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_B6;
    [self.contentView addSubview:lineView];
    
    [self.labTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.btnDele.mas_left).offset(-10);
    }];
    
    [self.btnDele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTxt);
        make.width.equalTo(@49);
        make.height.equalTo(_btnDele.mas_width);
        make.right.equalTo(self.contentView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labTxt);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadData:(NSString *)text {
    self.labTxt.text = text;
}

- (void)btnDeleteClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchCellDidDelete:)]) {
        [_delegate searchCellDidDelete:self];
    }
}

#pragma mark - setter and getter

- (UILabel *)labTxt {
    if (!_labTxt) {
        _labTxt = [[UILabel alloc] init];
        _labTxt.textColor = COLOR_B3;
        _labTxt.font = FONT_F4;
    }
    return _labTxt;
}

- (UIButton *)btnDele {
    if (!_btnDele) {
        _btnDele = [[UIButton alloc] init];
        [_btnDele setImage:[UIImage imageNamed:@"热门-phone搜索叉"] forState:UIControlStateNormal];
        [_btnDele addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDele setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 15)];
    }
    return _btnDele;
}

@end

#pragma mark - HotCell

@interface HotCell () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>

@property (nonatomic, strong) TTGTagCollectionView *ttCollection;

@end

@implementation HotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.contentView.backgroundColor = COLOR_B9;
    
    [self.contentView addSubview:self.ttCollection];
    [self.ttCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    return self.data[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(hotCellDidSelected:)]) {
        [_delegate hotCellDidSelected:index];
    }
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.data.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    return self.data[index];
}

- (void)loadData:(NSMutableArray *)data {
    if (data.count > 0) {
        [self.data removeAllObjects];
        for (NSInteger i = 0; i < data.count; i++) {
            [self.data addObject:[self newLabelWithText:data[i] font:FONT_F4 textColor:COLOR_B4 backgroundColor:COLOR_B9]];
        }
        [self.ttCollection reload];
    }
}

- (UILabel *)newLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroudColor {
    UILabel *label = [UILabel new];
    
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = backgroudColor;
    [label sizeToFit];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = COLOR_B6.CGColor;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4.0f;
    
    [self expandSizeForView:label extraWidth:28 extraHeight:10];
    
    return label;
}

- (void)expandSizeForView:(UIView *)view extraWidth:(CGFloat)extraWidth extraHeight:(CGFloat)extraHeight {
    CGRect frame = view.frame;
    frame.size.width += extraWidth;
    frame.size.height += extraHeight;
    view.frame = frame;
}

#pragma mark - event


#pragma mark - setter and getter

- (TTGTagCollectionView *)ttCollection {
    if (!_ttCollection) {
        _ttCollection = [[TTGTagCollectionView alloc] initWithFrame:CGRectZero];
        _ttCollection.delegate = self;
        _ttCollection.dataSource = self;
        _ttCollection.horizontalSpacing = 10.0;
        _ttCollection.verticalSpacing = 15.0;
        _ttCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsetsMake(5, 14, 5, 14);
    }
    return _ttCollection;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

@end


#pragma mark - SearchHeader

@interface SearchHeader ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgStr;

@end

@implementation SearchHeader

- (instancetype)initWith:(NSString *)title imgStr:(NSString *)imgStr {
    self = [super init];
    if (self) {
        _title = title;
        _imgStr = imgStr;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = COLOR_B9;
    
    [self addSubview:self.imgHeader];
    [self addSubview:self.labTitle];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@19);
        make.height.equalTo(_imgHeader.mas_width);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.imgHeader.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    self.labTitle.text = self.title;
    self.imgHeader.image = [UIImage imageNamed:self.imgStr];
}

#pragma mark - public

- (void)setLineHiden:(BOOL)lineHiden {
    if (!lineHiden) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_B6;
        [self addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = COLOR_B6;
        [self addSubview:lineView1];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.left.equalTo(self.mas_left).offset(15);
        }];
    }
}

#pragma mark - setter and getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = COLOR_B2;
        _labTitle.font = FONT_F3;
    }
    return _labTitle;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] init];
    }
    return _imgHeader;
}

@end

#pragma mark - SearchFooter

@interface SearchFooter ()

@property (nonatomic, copy) NSString *title;

@end

@implementation SearchFooter


- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = COLOR_B9;
    
    [self addSubview:self.btnBottom];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_B6;
    [self addSubview:lineView];
    
    [self.btnBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - setter and getter

- (UIButton *)btnBottom {
    if (!_btnBottom) {
        _btnBottom = [[UIButton alloc] init];
        [_btnBottom setTitle:_title forState:UIControlStateNormal];
        [_btnBottom setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnBottom.titleLabel.font = FONT_F4;
    }
    return _btnBottom;
}

@end
