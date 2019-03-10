//
//  TSAddEventController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSAddEventController.h"
#import "TSEventModel.h"

@interface TSAddEventController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBButton;

@end

@implementation TSAddEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Event";
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancelButton setTitleColor:[UIColor pf_colorWithHex:0x999999] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onTouchCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.saveBButton.layer.cornerRadius = 7;
    self.saveBButton.layer.borderWidth = 1;
    self.saveBButton.layer.borderColor = [UIColor pf_colorWithHex:0x2A77EA].CGColor;
    self.saveBButton.clipsToBounds = YES;
}

- (void)onTouchCancelClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTouchSaveBtn:(id)sender {
    if (!_nameTextField.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter the event name!"];
        return;
    } else if (!_countTextField.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter the event cycle!"];
        return;
    }
    NSInteger count = TSUserTool.sharedInstance.user.surplusLife;
    TSEventModel *model = [TSEventModel new];
    model.day = _countTextField.text.integerValue;
    model.name = [NSString stringWithFormat:@"%@ %zd times", _nameTextField.text, count / model.day];
    [self.datas addObject:model];
    self.didCompleteBlock(self.datas);
    [self dismissViewControllerAnimated:YES completion:nil];
    [LHHudTool showSuccessWithMessage:@"Save success"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
