//
//  TSAddTargetController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/3/10.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSAddTargetController.h"
#import "PFDatePicker.h"
#import "TSDateTool.h"

@interface TSAddTargetController ()
@property (weak, nonatomic) IBOutlet UITextField *targetTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBButton;

@end

@implementation TSAddTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add target";
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
    
    NSDateFormatter *df = [TSDateTool dateFormatter];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterMediumStyle;
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    _dateTextField.text = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate new] timeIntervalSince1970] + 300]];
}

- (void)onTouchCancelClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTouchSaveButton:(id)sender {
    if (!_targetTextField.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter the event target!"];
        return;
    }
    NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSTimeInterval time = [[dateFormatter dateFromString:self.dateTextField.text] timeIntervalSince1970];
    
    TSTargetModel *model = [TSTargetModel new];
    model.target = _targetTextField.text;
    model.time = [NSString stringWithFormat:@"%.0f", time];
    self.didCompleteBlock(model);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [LHHudTool showSuccessWithMessage:@"Save success"];
}

- (IBAction)onTouchDate:(id)sender {
    [self.view endEditing:YES];
    [PFDatePicker showWithDate:nil startYear:2019 title:@"Expiry Date" mode:PFDatePickerViewDateMode complete:^(NSString *dateStr) {
        NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *selectDate = [dateFormatter dateFromString:dateStr];
        dateFormatter.dateFormat = @"yyyy/MM/dd";
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSString *newDateStr = [dateFormatter stringFromDate:selectDate];
        self.dateTextField.text = newDateStr;
    }];
}

#pragma mark -


@end
