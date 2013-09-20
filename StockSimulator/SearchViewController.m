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
    NSMutableArray *searchResults;
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
        searchResults=[[NSMutableArray alloc]initWithObjects:@"Test",@"Test2", nil];
        table=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70) style:UITableViewStyleGrouped];
        [table setDataSource:self];
        [table setDelegate:self];
        [table setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
        [table setEditing:YES animated:YES];
        [self.view addSubview:table];
        
        bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 50)];
        bar.delegate=self;
        bar.showsCancelButton=YES;
        [self.view addSubview:bar];
        
    }
    return self;
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
    return [searchResults count];
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
        [searchResults removeObjectAtIndex:indexPath.row];
        [table reloadData];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    // fetch the object at the row being moved
    NSString *r = [searchResults objectAtIndex:fromIndexPath.row];
    
    // remove the original from the data structure
    [searchResults removeObjectAtIndex:fromIndexPath.row];
    
    // insert the object at the target row
    [searchResults insertObject:r atIndex:toIndexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = searchResults[indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_parent hideSearch];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
