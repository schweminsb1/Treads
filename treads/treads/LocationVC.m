//
//  LocationVC.m
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationVC.h"
#import "Comment.h"
#import "CommentCell.h"
#import "CommentEnterCell.h"
@interface LocationVC ()
@property NSMutableArray * commentModels;
@end

@implementation LocationVC
//class contains service and model and fills fields on page

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withModel: (Location *) model withCommentService: (CommentService *) service
{
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _commentService = service;
        _model=model;
        [_commentService getCommentInLocation:[model.idField intValue] forTarget:self withAction:@selector(getModels:)];
        
        CGRect commentEnterRect = CGRectMake(_commentTable.frame.origin.x, _commentTable.frame.origin.y -50, _commentTable.frame.size.width, 50);
        _commentEnterCell = [[CommentEnterBox alloc] initWithFrame:commentEnterRect];
        [self.view addSubview:_commentEnterCell];
        
        
    }
    else
    {
        NSLog(@"error in LocationVC");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name.text = _model.title;
    
    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
     self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
     
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
    self.name.text = _model.title;
    
    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
    self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
    
*/
    
}

-(void)getModels: (NSArray*) items
{
    _commentModels=(NSMutableArray *)items;
    //get users, and fill comentModel
    [_commentTable reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentModels.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    UITableViewCell * ccell= [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    
    if(indexPath.row == 0)
    {
        
        if (!ccell)
        {
            ccell = [[CommentEnterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" ];
            //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            //[cell setAutoresizesSubviews:YES];
        }
    }
    else if(indexPath.row >0)
    {
        if (!ccell)
        {
            ccell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" withCommentModel:((Comment *)_commentModels[indexPath.row-1])];
        //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        //[cell setAutoresizesSubviews:YES];
        }
    }
    
       return ccell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    
}


@end
