//
//  ViewController.m
//  writesqlite
//
//  Created by 大麦 on 16/2/22.
//  Copyright (c) 2016年 lsp. All rights reserved.
//

#import "ViewController.h"
#import "SqliteDB/SqliteDB.h"
@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *mutArray;
@property (strong, nonatomic) NSMutableArray *resultArray;//查询结果。显示在tableview上的
@property (strong, nonatomic) UITableView *tableV;

@end

#define createButtonWithStatus(buttonFrame,buttonTitle,buttonTitleColor)\
^(void)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
[button setTitle:buttonTitle forState:UIControlStateNormal];\
[button setTitleColor:buttonTitleColor forState:UIControlStateNormal];\
[button setFrame:buttonFrame];\
return button;\
}()

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self InterFace];
}

-(void)InterFace
{
    self.resultArray = [NSMutableArray array];
    //先打开再创建。
    self.mutArray = [NSMutableArray array];
    [self.mutArray addObject:@"创建"];
    [self.mutArray addObject:@"打开"];
    [self.mutArray addObject:@"插入"];
    [self.mutArray addObject:@"删除"];
    [self.mutArray addObject:@"修改"];
    [self.mutArray addObject:@"查询"];
    //
    int column = 3;//列
    int line = [self.mutArray count]/3;//行
    if([self.mutArray count]%column!=0)
    {
        line = line+1;
    }
    float nextY=0;
    for(int i=0;i<line;i++)
    {
        for(int j=0;j<column;j++)
        {
            NSString *buttonTitle = [self.mutArray objectAtIndex:(i*column+j)];
            UIColor *buttonTitleColor = [UIColor blackColor];
            CGRect buttonFrame = CGRectMake(10+100*j, 70+50*i, 100, 40);
            //
            UIButton *button = createButtonWithStatus(buttonFrame, buttonTitle, buttonTitleColor);
            button.tag = i*column+j+10;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            if(i==line-1)
            {
                if(i*column+j==[self.mutArray count]-1)
                {
                    nextY = button.frame.origin.y+button.frame.size.height+50;
                }
            }
        }
    }
    //
    float nextHeight = [UIScreen mainScreen].bounds.size.height-nextY-50;
    //
    self.tableV = [[UITableView alloc]init];
    [self.tableV setFrame:CGRectMake(10, nextY, 300, nextHeight)];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.view addSubview:self.tableV];
}

-(void)buttonAction:(UIButton *)button
{
    int index = button.tag-10;
    NSLog(@"%@",[self.mutArray objectAtIndex:index]);
    if(index==0)
    {
        [[SqliteDB sharedSqliteDB] createDB];
    }
    else if(index==1)
    {
        [[SqliteDB sharedSqliteDB] openDB];
    }
    else if(index==2)
    {
        [[SqliteDB sharedSqliteDB] inserDB];
    }
    else if(index==3)
    {
        [[SqliteDB sharedSqliteDB] deleteAll];
    }
    else if(index==4)
    {
        [[SqliteDB sharedSqliteDB] updateDB];
    }
    else if(index==5)
    {
//        [[SqliteDB sharedSqliteDB] searchDB];
//        [self refreshTableView];
    }
    [self refreshTableView];
}

-(void)refreshTableView
{
    NSMutableArray *arr = [[SqliteDB sharedSqliteDB] searchDBResult];
    if(self.resultArray)
    {
        [self.resultArray removeAllObjects];
        self.resultArray = arr;
        [self.tableV reloadData];
    }
}


#pragma mark -- UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetify = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetify];
    }
    NSMutableDictionary *dic = [self.resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.detailTextLabel.text = [dic valueForKey:@"age"];
    return cell;
}

@end
