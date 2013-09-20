//
//  SearchViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "SearchViewController.h"
#import "UserSettings.h"

@interface SearchViewController (){
    UITableView *table;
    UISearchBar *bar;
}

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        table=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65) style:UITableViewStylePlain];
        [table setDataSource:self];
        [table setDelegate:self];
        [table setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
        [table setEditing:YES animated:YES];
        [self.view addSubview:table];
        
        UIBarButtonItem *mySettingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        UIBarButtonItem *mySpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar *myTopToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,65)];
        
        [myTopToolbar setItems:[NSArray arrayWithObjects:mySettingsButton,mySpacer, nil] animated:NO];
        myTopToolbar.backgroundColor=[UIColor grayColor];
        [self.view addSubview:myTopToolbar];
        
        bar=[[UISearchBar alloc]initWithFrame:CGRectMake(50, 20, self.view.frame.size.width-50, 50)];
        bar.delegate=self;
        [bar setBackgroundImage:[UIImage new]];
        [bar setTranslucent:YES];
        bar.showsCancelButton=YES;
        [self.view addSubview:bar];
        
    }
    return self;
}
-(void)back{
    [_parent hideSearch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UserSettings sharedManager]stockTickers] count];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *stocks= [[[UserSettings sharedManager]stockTickers]mutableCopy];
        [stocks removeObjectAtIndex:indexPath.row];
        [[UserSettings sharedManager]setStockList:stocks];
        [table reloadData];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSString *r = [[[UserSettings sharedManager]stockTickers] objectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] removeObjectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] insertObject:r atIndex:toIndexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [[UserSettings sharedManager]stockTickers][indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selected=[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",selected.textLabel.text);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [bar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSMutableArray *stocks=[[[UserSettings sharedManager]stockTickers]mutableCopy];
    [stocks addObject:[NSString stringWithFormat:@"%@",searchBar.text]];
    [[UserSettings sharedManager]setStockList:stocks];
    [bar resignFirstResponder];
    [table reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [bar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
