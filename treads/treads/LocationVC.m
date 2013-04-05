//
//  LocationVC.m
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationVC.h"
#import "Comment.h"
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
    [_commentTable reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentModels.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.userInteractionEnabled = NO;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.userInteractionEnabled = NO;
        //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        //[cell setAutoresizesSubviews:YES];
    }
    
    cell.textLabel.text= ((Comment *)_commentModels[indexPath.row]).comment;
    
    return cell;
}

@end
