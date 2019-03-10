//
//  TSEventListController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/26.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSEventListController.h"
#import "TSEventListCell.h"
#import "TSDateTool.h"
#import "TSAddEventController.h"

@interface TSEventListController ()

@property (nonatomic, copy) NSString *fileName;

    
@end

@implementation TSEventListController

// 重写初始化方法
- (instancetype)init {
    if (self = [super initWithNibName:@"TSTableViewController" bundle:nil]) {
        // 初始化
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Event";
    [self.tableView registerNib:[UINib nibWithNibName:@"TSEventListCell" bundle:nil] forCellReuseIdentifier:TSEventListCell.identifer];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_e"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchAdd)];
}

#pragma mark - Touvh
- (void)onTouchAdd {
    TSAddEventController *v = [TSAddEventController new];
    v.datas = self.datas;
    v.didCompleteBlock = ^(NSMutableArray * _Nonnull datas) {
        self.datas = datas;
        [[self.datas modelToJSONObject] writeToFile:self.fileName atomically:NO];
        [self.tableView reloadData];
    };
    [self presentViewController:[[TSNavigationController alloc] initWithRootViewController:v] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSEventListCell *cell = [tableView dequeueReusableCellWithIdentifier:TSEventListCell.identifer];
    cell.model = self.datas[indexPath.row];
    cell.didClickItemCellBlock = ^(TSEventModel *model) {
        self.s_model.selected = NO;
        model.selected = YES;
        [[self.datas modelToJSONObject] writeToFile:self.fileName atomically:NO];
        SAFE_BLOCK(self.didCompleteBlcok, model);
        [self.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)datas {
    NSMutableArray *tempDatas = [super datas];
    if (tempDatas.count) {
        return tempDatas;
    }
    _fileName = [[TSTools getCurrentUserCacheFolderWithFolderName:@"events"] stringByAppendingString:@"/eventArr.plist"];
    NSArray *homeEventArr = [NSArray arrayWithContentsOfFile:_fileName];
    if (!homeEventArr) {
        NSInteger count = TSUserTool.sharedInstance.user.surplusLife;
        TSEventModel *model1 = [TSEventModel new];
        model1.name = [NSString stringWithFormat:@"Sleep %zd times", count / model1.day];
        
        TSEventModel *model2 = [TSEventModel new];
        model2.name = [NSString stringWithFormat:@"Bathe %zd times", count / model2.day];
        
        TSEventModel *model3 = [TSEventModel new];
        model3.day = 180;
        model3.name = [NSString stringWithFormat:@"Travel %ld times", count / model3.day]; // 半年一次
        
        TSEventModel *model4 = [TSEventModel new];
        model4.name = [NSString stringWithFormat:@"ReadBook %zd times", count / model4.day];
        
        TSEventModel *model5 = [TSEventModel new];
        model5.name = [NSString stringWithFormat:@"PlayGame %zd times", count / model5.day];
        
        TSEventModel *model6 = [TSEventModel new];
        model6.day = 30;
        model6.name = [NSString stringWithFormat:@"GetPaid %ld times", count / model6.day]; // 30天一次
        
        homeEventArr = @[[model1 modelToJSONObject],
                         [model2 modelToJSONObject],
                         [model3 modelToJSONObject],
                         [model4 modelToJSONObject],
                         [model5 modelToJSONObject],
                         [model6 modelToJSONObject]];
        [homeEventArr writeToFile:_fileName atomically:NO];
    }
    tempDatas = [NSArray modelArrayWithClass:TSEventModel.class json:homeEventArr].mutableCopy;
    [tempDatas enumerateObjectsUsingBlock:^(TSEventModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:self.s_model.name]) {
            obj.selected = obj;
        } else {
            obj.selected = NO;
        }
    }];
    return tempDatas;
}


@end
