//
//  ViewController.m
//  LHJ
//
//  Created by 王勇 on 2018/11/7.
//  Copyright © 2018年 王勇. All rights reserved.
//

#import "ViewController.h"

#define windowWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
{
    NSArray *_dataArray;          //奖品数组
    UIView *_selectImageView;     //移动光标
    UIView *_selectItem;
    
    UIImageView *_selectPrize;   //中奖商品展示

    int seconds;
    float totalSecond;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    seconds = 0.0;
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    selectView.layer.borderColor = [UIColor redColor].CGColor;
    selectView.layer.borderWidth = 2.0;
    selectView.backgroundColor = [UIColor colorWithRed:255.0 green:0 blue:0 alpha:.1];
    selectView.layer.cornerRadius = 8.0;
    _selectImageView = selectView;
    
    NSArray *array = @[@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"gb1.png",@"img6.png",@"s1.png",@"img6.png",@"gb1.png",@"img6.png"];
    _dataArray = array;
    
    CGFloat X = (windowWidth - 40*7)/2.0;
    
    CGFloat width = 0;
    CGFloat itemY = 0;
    
    int lineNum = (int)array.count / 4; //平均每列的排列个数
    
    for (int i=0; i<array.count; i++) {
        
        if (i/lineNum == 0) {
            width = X + 40 *(i%lineNum);
            itemY = 80;
        }else if (i/lineNum == 1){
            width = X + 40 *lineNum;
            itemY = 80 + 40 *(i%lineNum);
        }else if (i/lineNum == 2){
            width = X + 40 *(lineNum-(i%lineNum));
            itemY = 80 + 40 *lineNum;
        }else{
            width = X;
            itemY = 80 + 40 * (lineNum-(i%lineNum));
        }
        
        UIImageView *itemView = [[UIImageView alloc] initWithFrame:CGRectMake(width, itemY, 40, 40)];
        itemView.image = [UIImage imageNamed:array[i]];
        itemView.layer.borderColor = [UIColor blueColor].CGColor;
        itemView.layer.borderWidth = 1.0;
        itemView.layer.cornerRadius = 8.0;
        itemView.tag = 100 + i;
        [self.view addSubview:itemView];
        
        if (i==0) {
            selectView.center = itemView.center;
            _selectItem = itemView;
        }
        
    }
    
    [self.view addSubview:selectView];
    
    //中奖后的展示
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X + 40*(lineNum/2.0), 200, 40, 40)];
    selectImageView.layer.borderColor = [UIColor blueColor].CGColor;
    selectImageView.layer.borderWidth = 1.0;
    selectImageView.layer.cornerRadius = 8.0;
    _selectPrize = selectImageView;
    [self.view addSubview:selectImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((windowWidth - 100)/2.0, 400, 100, 40);
    btn .backgroundColor = [UIColor greenColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
#pragma mark - 开始旋转动画
- (void)startAction
{
    //获取随机转动圈数  可以根据用户需求随意更改
    int second = [self getRandomNumber:5 to:8];
    //获取随机终点  可以根据用户需求随意更改
    int endTag = [self getRandomNumber:0 to:(int)_dataArray.count - 1] + 100;
    
    totalSecond = 5; //开始和结束变慢时间
    seconds =0;      //已转动圈数
    
    _selectPrize.image = nil;
    [self startRotateAnimation:second selectTag:_selectItem.tag endTag:endTag];
}
#pragma mark  - 开始前4个  ，结束之前的4个移动速度逐渐变化
- (void)startRotateAnimation:(int)second selectTag:(NSInteger)selectTag  endTag:(int)endTag{

    NSInteger tag = (_selectItem.tag - 100 + 1) % _dataArray.count + 100;
    if ((_selectItem.tag - 100 + 1) % _dataArray.count + 100 == selectTag ) {
        if (seconds < second) {
            seconds++;//转到原点转动圈数增加
        }
    }
    UIView *item = [self.view viewWithTag:(self->_selectItem.tag - 100 + 1) % _dataArray.count + 100];
    
    if (totalSecond > 1 && seconds == 0){
        //刚开始
        [UIView animateWithDuration:totalSecond/10.0 animations:^{
            self->_selectImageView.center = item.center;
        } completion:^(BOOL finished) {
            self->_selectItem = item;
            self->totalSecond = self->totalSecond - 1;
            [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
        }];
    }else if (seconds == second){
        //结束前的减速
        if (endTag>=104 && tag > endTag - 4) {
            if (tag > endTag - 4 && tag <= endTag) {
                [UIView animateWithDuration:totalSecond/10.0 animations:^{
                    self->_selectImageView.center = item.center;
                } completion:^(BOOL finished) {
                    self->_selectItem = item;
                    if (tag == endTag) {
                        UIImageView *itemImage = (UIImageView *)item;
                        
                        NSLog(@"endTag=%d,tag=%ld",endTag,(long)itemImage.tag);
                        self->_selectPrize.image = itemImage.image;
                        [self->_selectImageView.layer addAnimation:[self opacityForever_Animation:0.1] forKey:nil];
                    }else{
                        self->totalSecond = self->totalSecond + 1;
                        [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
                    }
                    
                }];
            }else{
                [UIView animateWithDuration:.02 animations:^{
                    self->_selectImageView.center = item.center;
                } completion:^(BOOL finished) {
                    self->_selectItem = item;
                    [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
                }];
            }
            
        }else if (endTag < 104) {
            if (tag > 100 + _dataArray.count - 4 + (endTag - 100) || tag <= endTag) {
                [UIView animateWithDuration:totalSecond/10.0 animations:^{
                    self->_selectImageView.center = item.center;
                } completion:^(BOOL finished) {
                    self->_selectItem = item;
                    if (tag == endTag) {
                        UIImageView *itemImage = (UIImageView *)item;
                        NSLog(@"endTag=%d,tag=%ld",endTag,(long)itemImage.tag);
                        self->_selectPrize.image = itemImage.image;
                        [self->_selectImageView.layer addAnimation:[self opacityForever_Animation:0.1] forKey:nil];
                    }else{
                        self->totalSecond = self->totalSecond + 1;
                        [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
                    }
                    
                }];     
            }else{
                [UIView animateWithDuration:.02 animations:^{
                    self->_selectImageView.center = item.center;
                } completion:^(BOOL finished) {
                    self->_selectItem = item;
                    [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
                }];
            }
            
        }else{
            [UIView animateWithDuration:.02 animations:^{
                self->_selectImageView.center = item.center;
            } completion:^(BOOL finished) {
                self->_selectItem = item;
                [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
            }];
        }
        
    }else{
        totalSecond = 1;
        [UIView animateWithDuration:.02 animations:^{
            self->_selectImageView.center = item.center;
        } completion:^(BOOL finished) {
            self->_selectItem = item;
            [self startRotateAnimation:second selectTag:selectTag endTag:endTag];
        }];
    }
}
#pragma mark - 获取区间随机数
-(double)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
#pragma mark - 中奖之后 闪烁3下
-(CABasicAnimation *)opacityForever_Animation:(float)time

{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = 4;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
