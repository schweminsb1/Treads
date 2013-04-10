//
//  ImageService.m
//  treads
//
//  Created by Sam Schwemin on 4/9/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//
//Blob name is the imageid, located in the images container
#import "ImageService.h"
#import "DataRepository.h"
#import "NSData+Base64.h"
@implementation ImageService


- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"ImageTable";
        _imageTable = [_dataRepository.client getTable:_dataTableIdentifier];
    }
    return self;
}
-(NSString *) stringFromImage: (UIImage *) image
{
    NSString * s;
   
    NSData * data = UIImagePNGRepresentation(image);
    s = [data base64EncodedString];
    
    return s;
}
-(UIImage *) imageFromString: (NSString *)imageString
{
   
    NSData *data = [NSData dataFromBase64String:imageString];
    UIImage *image = [UIImage imageWithData:data];
    
    
    return image;
}

-(void) insertImageAsBlob:(UIImage *) image withCompletion:(MSItemBlock) ultimatecompletionblock
{
    CompletionWithSasBlock comp= ^(NSString* sas){
        
        _SASURL=sas;
        NSData * data= UIImagePNGRepresentation(image);
        NSMutableURLRequest * request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_SASURL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%d", data.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                      delegate:self];
        [connection start];
        
        //write to the url the UIIMageData
       
    };
    
    CompletionWithItems complwithitems= ^(NSArray * items)
    {
        _imagesSizeNextImageID=items.count+5;
     [_dataRepository getSasUrlForNewBlob:[NSString stringWithFormat:@"%d",_imagesSizeNextImageID] forContainer:@"images" withCompletion:comp];
        
        _comp=ultimatecompletionblock;
    };
   
        [_dataRepository retrieveDataItemsMatching:@"id > -1" usingService:self withReturnBlock:complwithitems ];
        
        
        //insert image path into database for a newID


  
}
-(void) getImageWithPhotoID:(int) photoid withReturnBlock:(CompletionWithItems) comp
{
    CompletionWithSasBlock completion= ^(NSString* sas){
        
        _SASURL=sas;
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:_SASURL]];
  
      //  UIImage * image= [UIImage imageWithData:data];
       // NSArray * results= @[image];
       // comp(results);

        
        //write to the url the UIIMageData
        
    };

    [_dataRepository getSasUrlForNewBlob:[NSString stringWithFormat:@"%d",photoid] forContainer:@"images" withCompletion:completion];

    
}


- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData

{
    
    return returnData;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//post to the database the newdata item
    NSMutableDictionary * dictionary= [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%d",_imagesSizeNextImageID] forKey:@"blobPath"];
    [_dataRepository createDataItem:dictionary usingService:self withReturnBlock:_comp];
}


@end
