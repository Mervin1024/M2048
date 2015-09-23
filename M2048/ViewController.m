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
    gameViewController = [[GameViewController alloc] init];
    [self addChildViewController:gameViewController];
    [self.view addSubview:gameViewController.view];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStepNumber:) name:@"update_stepNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentScore:) name:@"update_currentScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnd) name:@"gameEnd" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)changeStepNumber:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    self.stepNumberLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"stepNumber"]];
}

- (void)changeCurrentScore:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    NSUInteger currentScore = [[dic objectForKey:@"score"] integerValue];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d",currentScore];
    if (currentScore > maxScore) {
        maxScore = currentScore;
        self.maximumScoreLabel.text = [NSString stringWithFormat:@"%d",maxScore];
        [[NSUserDefaults standardUserDefaults] setObject:@(maxScore) forKey:@"maximumScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)gameEnd{
    NSLog(@"游戏结束!");
}

@end
