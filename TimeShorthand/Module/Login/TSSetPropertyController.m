//
//  TSSetPropertyController.m
//  TimeShorthand
//
//  Created by liuhao on 2019/2/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "TSSetPropertyController.h"
#import "AppDelegate.h"
#import "PFDatePicker.h"
#import "TSDateTool.h"

@interface cirlemodel:NSObject
@property(assign,nonatomic)CGFloat orignX;
@property(assign,nonatomic)CGFloat orignY;
@property(assign,nonatomic)CGFloat width;
@property(assign,nonatomic)CGFloat offsetX;
@property(assign,nonatomic)CGFloat offsetY;
- (instancetype)initModelWith:(CGFloat)orignx andy:(CGFloat)origny andwidth:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety;
@end

@interface linemodel:NSObject
@property(assign,nonatomic)CGFloat beginX;
@property(assign,nonatomic)CGFloat beginY;
@property(assign,nonatomic)CGFloat opacity;
@property(assign,nonatomic)CGFloat closeX;
@property(assign,nonatomic)CGFloat closeY;
- (instancetype)initModelWith:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey;
@end

@interface TSSetPropertyController ()

@property(assign,nonatomic)CGFloat screenWidth;
@property(assign,nonatomic)CGFloat screenHeight;
@property(strong,nonatomic)UIView *bgview;
@property(assign,nonatomic)NSUInteger point;
@property(strong,nonatomic)NSMutableArray *cirleArry;
@property(strong,nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *lifeTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TSSetPropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onTouchCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn sizeToFit];
    [self.view addSubview:_closeBtn];
    _closeBtn.left = 15.0f;
    _closeBtn.top = 15.0f + [UIView safeAreaTop];
    
    [self.view insertSubview:self.bgview aboveSubview:self.scrollView];
    [self initprama];
    [self draw];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
}

- (void)setupInit {
    NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    self.timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    self.nameTextField.text = TSUserTool.sharedInstance.user.name;
    self.lifeTextField.text = TSUserTool.sharedInstance.user.life;
}

- (IBAction)onTouchBirthDay:(id)sender {
    [self.view endEditing:YES];
    [PFDatePicker showWithTitle:@"Set birthday" mode:PFDatePickerViewDateMode complete:^(NSString *dateStr) {
        NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *selectDate = [dateFormatter dateFromString:dateStr];
        dateFormatter.dateFormat = @"yyyy/MM/dd";
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSString *newDateStr = [dateFormatter stringFromDate:selectDate];
        self.timeLabel.text = newDateStr;
    }];
}

- (void)onTouchCloseBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTouchCompleteButton:(id)sender {
    [self.view endEditing:YES];
    if (!_nameTextField.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter your nickname!"];
        return;
    } else if (!_timeLabel.text.length) {
        [LHHudTool showErrorWithMessage:@"Please choose your birthday!"];
        return;
    } else if (!_lifeTextField.text.length) {
        [LHHudTool showErrorWithMessage:@"Please enter life!"];
        return;
    }
    [LHHudTool showLoading];
    
    
    
    NSDateFormatter *dateFormatter = [TSDateTool dateFormatter];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSTimeInterval time = [[dateFormatter dateFromString:self.timeLabel.text] timeIntervalSince1970];
    
    TSUser *user = [TSUserTool sharedInstance].user;
    user.life = self.lifeTextField.text;
    user.name = self.nameTextField.text;
    user.birthday = [NSString stringWithFormat:@"%.0f", time];
    
    AVUser *currentUser = [AVUser currentUser];
    [currentUser setObject:user.name forKey:@"name"];
    [currentUser setObject:user.life forKey:@"life"];
    [currentUser setObject:user.birthday forKey:@"birthday"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [LHHudTool showErrorWithMessage:error.localizedFailureReason ? : kServiceErrorString];
            return;
        }
        NSString *imageDir = [TSTools getCurrentUserCacheFolderWithFolderName:@""];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imageDir error:nil];
        // 存储成功
        [LHHudTool showSuccessWithMessage:@"Save success"];
        [self didClickComplete];
    }];
}

- (void)didClickComplete {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setupRootViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initprama{
    _screenWidth=[UIScreen mainScreen].bounds.size.width;
    _screenHeight=[UIScreen mainScreen].bounds.size.height;
    _point=13;
    _cirleArry=[NSMutableArray arrayWithCapacity:_point];
    for (NSUInteger i=0; i<_point; i++) {
        cirlemodel *cirle=[[cirlemodel alloc]initModelWith:[self randomBetween:0 And:self.screenWidth] andy:[self randomBetween:0 And:self.screenHeight] andwidth:[self randomBetween:1 And:9] andOffsetX:[self randomBetween:10 And:-10]/40 andOffsetY:[self randomBetween:10 And:-10]/40];
        [_cirleArry addObject:cirle];
    }
    
}


- (void)run{
    [self.bgview removeFromSuperview];
    self.bgview=nil;
    [self.view insertSubview:self.bgview atIndex:0];
    for (int i=0; i<_point; i++) {
        cirlemodel *model=_cirleArry[i];
        model.orignX+=model.offsetX;
        model.orignY+=model.offsetY;
        if (model.orignX>_screenWidth) {
            model.orignX=0;
        }else if(model.orignX<0){
            model.orignX=_screenWidth;
        }
        
        if (model.orignY>_screenHeight) {
            model.orignY=0;
        }else if (model.orignY<0){
            model.orignY=_screenHeight;
        }
    }
    [self draw];
    
}

- (void)draw{
    
    for (cirlemodel *model in _cirleArry) {
        [self drawCirleWithPrama:model.orignX andy:model.orignY andRadio:model.width andOffsetX:model.offsetX andOffsetY:model.offsetY];
    }
    for (int i=0; i<_point; i++) {
        for (int j=0; j<_point; j++) {
            if (i+j<_point) {
                cirlemodel *model1=_cirleArry[i+j];
                cirlemodel*model2=_cirleArry[i];
                float a=ABS(model1.orignX-model2.orignX);
                float b=ABS(model1.orignY-model2.orignY);
                float length=sqrtf(a*a+b*b);
                float lineOpacity;
                if (length<=_screenWidth/2) {
                    lineOpacity=0.2;
                }else if (_screenWidth/2>length>_screenWidth){
                    lineOpacity=0.15;
                }else if(_screenWidth>length>_screenHeight/2){
                    lineOpacity=0.1;
                }else{
                    lineOpacity=0.0;
                }
                if (lineOpacity>0) {
                    [self drawLinewithPrama:model2.orignX andy:model2.orignY andOpacity:lineOpacity andCloseX:model1.orignX andCloseY:model1.orignY];
                }
            }
        }
    }
    
}

- (UIView*)bgview{
    if (!_bgview) {
        _bgview =  [UIView new];
        _bgview.frame=self.view.bounds;
        _bgview.backgroundColor=[UIColor whiteColor];
    }
    return _bgview;
}

//随机返回某个区间范围内的值
- (float) randomBetween:(float)smallerNumber And:(float)largerNumber
{
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int)subtraction+1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

/*
 画圈
 */
- (void)drawCirleWithPrama:(CGFloat)beginx andy:(CGFloat)beginy andRadio:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety{
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 7.0f ;
    solidLine.strokeColor = [UIColor colorWithRed:63/255.0f green:115/255.0f blue:50/255.0f alpha:0.4].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(beginx,  beginy, width, width));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.bgview.layer addSublayer:solidLine];
    
}

/*
 划线
 */

- (void)drawLinewithPrama:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey{
    
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[UIColor colorWithRed:63/255.0f green:115/255.0f blue:50/255.0f alpha:opacity].CGColor];
    solidShapeLayer.lineWidth =0.5f ;
    CGPathMoveToPoint(solidShapePath, NULL, beginx, beginy);
    CGPathAddLineToPoint(solidShapePath, NULL, closex,closey);
    
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.bgview.layer addSublayer:solidShapeLayer];
}
@end


@implementation cirlemodel

- (instancetype)initModelWith:(CGFloat)orignx andy:(CGFloat)origny andwidth:(CGFloat)width andOffsetX:(CGFloat)offsetx andOffsetY:(CGFloat)offsety{
    
    if (self=[super init]) {
        self.orignX=orignx;
        self.orignY=origny;
        self.width=width;
        self.offsetX=offsetx;
        self.offsetY=offsety;
    }
    return self;
    
}

@end


@implementation linemodel

- (instancetype)initModelWith:(CGFloat)beginx andy:(CGFloat)beginy andOpacity:(CGFloat)opacity andCloseX:(CGFloat)closex andCloseY:(CGFloat)closey{
    
    if (self=[super init]) {
        self.beginX=beginx;
        self.beginY=beginy;
        self.opacity=opacity;
        self.closeX=closex;
        self.closeY=closey;
    }
    return self;
    
}

@end
