//
//  ViewController.m
//  M2048
//
//  Created by sh219 on 15/9/21.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController (){
    GameViewController *gameViewController;
    NSUInteger maxScore;
    UIView *maskView;
    NSMutableArray *viewArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *stepNumberImage;
@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentScoreImage;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maximumScoreImage;
@property (weak, nonatomic) IBOutlet UILabel *maximumScoreLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewArray = [NSMutableArray arrayWithCapacity:3];
    gameViewController = [[GameViewController alloc] init];
    [self addChildViewController:gameViewController];
    [self.view addSubview:gameViewController.view];
    
    [self initScoreLable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStepNumber:) name:@"update_stepNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentScore:) name:@"update_currentScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnd) name:@"gameEnd" object:nil];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameEnd)];
//    [self.view addGestureRecognizer:tap];
    CGRect frame = gameViewController.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(frame.origin.x, frame.origin.y-21, 70, 21)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initScoreLable{
    [self.stepNumberImage.layer setMasksToBounds:YES];
    [self.stepNumberImage.layer setCornerRadius:8.0];
    [self.currentScoreImage.layer setMasksToBounds:YES];
    [self.currentScoreImage.layer setCornerRadius:8.0];
    [self.maximumScoreImage.layer setMasksToBounds:YES];
    [self.maximumScoreImage.layer setCornerRadius:8.0];
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"maximumScore"];
    if (!num) {
        maxScore = 0;
        
    }else{
        maxScore = [num integerValue];
    }
    self.maximumScoreLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)maxScore];
    self.currentScoreLabel.text = @"0";
    self.stepNumberLabel.text = @"0";
}

- (void)changeStepNumber:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    self.stepNumberLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"stepNumber"]];
}

- (void)changeCurrentScore:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    NSUInteger currentScore = [[dic objectForKey:@"score"] integerValue];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)currentScore];
    if (currentScore > maxScore) {
        maxScore = currentScore;
        self.maximumScoreLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)maxScore];
        [[NSUserDefaults standardUserDefaults] setObject:@(maxScore) forKey:@"maximumScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)gameEnd{
    [self showSoreLabel];
    
}

- (void)showSoreLabel{
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.0f;
        maskView.tag = 2;
        [self.view addSubview:maskView];
        NSUInteger currentScore = [self.currentScoreLabel.text integerValue];
        NSUInteger maximumScore = [self.maximumScoreLabel.text integerValue];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"重新开始" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/8)];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 4;
        [button addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/8)];
        currentLabel.backgroundColor = [UIColor whiteColor];
        currentLabel.font = [UIFont boldSystemFontOfSize:20];
        currentLabel.adjustsFontSizeToFitWidth = YES;
        currentLabel.textAlignment = NSTextAlignmentCenter;
        currentLabel.tag = 5;
        
        if (currentScore < maximumScore) {
            currentLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/8*3);
            button.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/8*4);
        }else{
            UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/8)];
            maxLabel.font = [UIFont boldSystemFontOfSize:21];
            maxLabel.text = @"你获得了新的最高分!";
            maxLabel.adjustsFontSizeToFitWidth = YES;
            currentLabel.textAlignment = NSTextAlignmentCenter;
            maxLabel.backgroundColor = [UIColor whiteColor];
            maxLabel.tag = 6;
            maxLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/8*3);
            currentLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/8*4);
            button.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/8*5);
            [self.view addSubview:maxLabel];
            [viewArray addObject:maxLabel];
        }
        
        [self.view addSubview:button];
        [self.view addSubview:currentLabel];
        [viewArray addObject:button];
        [viewArray addObject:currentLabel];
    }
    UILabel *currentLabel = (UILabel *)[self.view viewWithTag:5];
    currentLabel.text = [NSString stringWithFormat:@"您当前得分：%@",self.currentScoreLabel.text];
    if ([viewArray count] > 2) {
        UILabel *maxLabel = (UILabel *)[self.view viewWithTag:6];
        maxLabel.text = [NSString stringWithFormat:@"您当前得分：%@",self.maximumScoreLabel.text];
    }
    
    [self showSoreAnimation];
}

- (void)showSoreAnimation{
    for (UIView *view in viewArray) {
        view.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT/16*11);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        maskView.alpha = 0.8f;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in viewArray) {
                view.transform = CGAffineTransformIdentity;
            }
        }];
    }];
}

- (void)reStart:(UIButton *)button{
    for (UIView *view in viewArray) {
        view.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT/16*11);
    }
    maskView.alpha = 0.0f;
    [self initScoreLable];
    [gameViewController reStart];
}

@end
