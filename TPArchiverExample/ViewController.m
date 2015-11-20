//
//  ViewController.m
//  TPArchiverExample
//
//  Created by abc on 15/11/18.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "ViewController.h"
#import "TPArchiver.h"
#import "TPTestModel.h"

@interface ViewController ()
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *overViewLabel;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UILabel *authorLabel;
@property (nonatomic , strong) UIAlertController *alertController;
@property (nonatomic , copy) NSString *archiverPath;
@property (nonatomic , strong) UIButton *archiverButton;
@property (nonatomic , strong) UIButton *unarchiverButton;
@property (nonatomic , strong) UIButton *clearButton;
@end

@implementation ViewController

#pragma mark - 归档

- (void)encodeData{
    //利用TPArchiver让自定义的类实现归档、解档功能 !!!!!!!!!!!!!!!!
    [TPArchiver archiverWithAllArchiverClasses:@[[TPTestModel class]]];
    
    //创建数据
    TPTestModel *testModel = [[TPTestModel alloc] init];
    testModel.title = @"一步让自定义的类实现归档、解档";
    testModel.overView = @"\n 导入TPArchiver到工程中\n #import头文件TPARchiver.h\n 调用类方法archiverWithAllArchiverClasses: ，参数为需要进行归档解档类的class数组\n 调用该方法后，即可对自定的类使用NSKeyedArchiver 、NSKeyedUnarchiver进行归档、解档操作";
    testModel.time = 20151118;
    testModel.author = @"TangPiece";
    testModel.success = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"归档" message:@"提示信息" preferredStyle:UIAlertControllerStyleAlert];
    //NSKeyedArchiver归档
    //归档成功
    if([NSKeyedArchiver archiveRootObject:testModel toFile:self.archiverPath]){
        TPTestModel *tempTestModel = [[TPTestModel alloc] init];
        tempTestModel.title = @"归档成功";
        tempTestModel.overView = @"解档即可显示归档的信息，可以按照控制台打印出的绝对路径查看生成的文件";
        tempTestModel.time = 0;
        tempTestModel.author = @" ";
        tempTestModel.success = YES;
        [self showContentWithTestModel:tempTestModel];
        alertController.title = @"归档成功";
        alertController.message = @"解档即可显示归档的信息，可以按照控制台打印出的绝对路径查看生成的文件";
        NSLog(@"archiver file path:%@" , self.archiverPath);
    }
    //归档失败
    else{
        alertController.title = @"归档失败";
        alertController.message = @"sorry , 不知道什么原因归档失败";
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
    //弹出提示框
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 解档

- (void)decodeData{
    //利用TPArchiver让自定义的类实现归档、解档功能 !!!!!!!!!!!!!!!!
    [TPArchiver archiverWithAllArchiverClasses:@[[TPTestModel class]]];
    
    //NSKeyedUnarchiver解档
    TPTestModel *testModel = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archiverPath];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"解档" message:@"提示信息" preferredStyle:UIAlertControllerStyleAlert];
    //没取到数据
    if (!testModel) {
        //提示用户解档失败，先进行归档
        alertController.title = @"解档失败";
        alertController.message = @"解档文件不存在，请先进行归档";
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            //再次弹出解档归档视图
            [self presentViewController:self.alertController animated:YES completion:nil];
        }]];
    }else{ //解档成功
        alertController.title = @"解档成功";
        alertController.message = @"解档文件中的信息已显示在视图中";
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self showContentWithTestModel:testModel];
    }
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
    //弹出提示框
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.archiverButton];
    [self.view addSubview:self.unarchiverButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.overViewLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.authorLabel];
}

- (void)viewWillLayoutSubviews{
    CGFloat overViewheight = self.view.bounds.size.height * 0.5f;
    CGFloat otherHeight = 50.0f;
    CGFloat startY = 64.0f;
    CGFloat inset = 10.0f;
    CGFloat width = self.view.bounds.size.width - inset * 2;
    CGFloat buttonWidth = width * 0.3f;
    
    self.archiverButton.frame = CGRectMake(inset , startY , buttonWidth , otherHeight);
    self.unarchiverButton.frame = CGRectMake(CGRectGetMaxX(self.archiverButton.frame), startY , buttonWidth , otherHeight);
    self.clearButton.frame = CGRectMake(CGRectGetMaxX(self.unarchiverButton.frame), startY, buttonWidth, otherHeight);
    self.titleLabel.frame = CGRectMake(inset , CGRectGetMaxY(self.archiverButton.frame) , width, otherHeight);
    self.overViewLabel.frame = CGRectMake(inset , CGRectGetMaxY(self.titleLabel.frame), width, overViewheight);
    self.timeLabel.frame = CGRectMake(inset, CGRectGetMaxY(self.overViewLabel.frame), width, otherHeight);
    self.authorLabel.frame = CGRectMake(inset, CGRectGetMaxY(self.timeLabel.frame), width, otherHeight);
    
    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.overViewLabel.backgroundColor = [UIColor grayColor];
    self.timeLabel.backgroundColor = [UIColor greenColor];
    self.authorLabel.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [self showAlertView];
}

#pragma mark - private methods

- (void)showAlertView{
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"归档" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self encodeData];
    }]];
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"解档" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self decodeData];
    }]];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)showContentWithTestModel:(TPTestModel *)testModel{
    if (!testModel) {
        self.titleLabel.text = @"归档文件已删除";
        self.overViewLabel.text = @"归档文件已删除";
        self.timeLabel.text = @"归档文件已删除";
        self.authorLabel.text = @"归档文件已删除";
        return;
    }
    self.titleLabel.text = [@"标题：" stringByAppendingString:testModel.title];
    self.overViewLabel.text = [@"概述：" stringByAppendingString:testModel.overView];
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%ld sucess:%d" , testModel.time , testModel.success];
    self.authorLabel.text = [@"作者：" stringByAppendingString:testModel.author];
}

- (void)clearData:(UIButton *)button{
    [self showContentWithTestModel:nil];
    if([[NSFileManager defaultManager] fileExistsAtPath:self.archiverPath]){
        [[NSFileManager defaultManager] removeItemAtPath:self.archiverPath error:nil];
    }
}

#pragma mark - getter方法

- (NSString *)archiverPath{
    if (!_archiverPath) {
        _archiverPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask , YES) firstObject] stringByAppendingPathComponent:@"test.archiver"];
    }
    return _archiverPath;
}

- (UIAlertController *)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"归档解档" message:@"测试只需一步让自定义的类具有归档能力" preferredStyle:UIAlertControllerStyleAlert];
    }
    return _alertController;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题：";
    }
    return _titleLabel;
}

- (UILabel *)overViewLabel{
    if (!_overViewLabel) {
        _overViewLabel = [[UILabel alloc] init];
        _overViewLabel.numberOfLines = 0;
        _overViewLabel.text = @"概述：";
    }
    return _overViewLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间：";
    }
    return _timeLabel;
}

- (UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.text = @"作者：";
    }
    return _authorLabel;
}

- (UIButton *)archiverButton{
    if (!_archiverButton) {
        _archiverButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_archiverButton setTitle:@"归档" forState:UIControlStateNormal];
        [_archiverButton addTarget:self action:@selector(encodeData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _archiverButton;
}

- (UIButton *)unarchiverButton{
    if (!_unarchiverButton) {
        _unarchiverButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_unarchiverButton setTitle:@"解档" forState:UIControlStateNormal];
        [_unarchiverButton addTarget:self action:@selector(decodeData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unarchiverButton;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clearButton setTitle:@"清空数据" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

@end
