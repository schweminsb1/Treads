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

#import "ImageCache.h"

@implementation ImageService

static ImageService* repo;
+(ImageService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[ImageService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

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

-(void) insertImage:(UIImage *) image withCompletion:(MSItemBlock) ultimatecompletionblock
{
    
    NSMutableDictionary * imageDict= [[NSMutableDictionary alloc]init];
    NSString * stringToSend= [self stringFromImage:image];
    if (stringToSend) {
        [imageDict setValue:stringToSend forKey:@"imageString"];
//        [imageDict setValue:@"" forKey:@"blobPath"];
        
        [_dataRepository createDataItem:imageDict usingService:self withReturnBlock:ultimatecompletionblock];
        //insert image path into database for a newID
    }

  
}
-(void) getImageWithPhotoID:(int) photoid withReturnBlock:(CompletionWithItems) comp
{
    //get image from cache if it exists, else, grab from database
    UIImage* image = [[ImageCache sharedCache] tryReadImageFromCacheWithID:photoid];
    if (image) {
        comp(@[image]);
    }
    else {
        [_dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = %d",photoid] usingService:self withReturnBlock:comp];
    }
}


- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    if (returnData.count > 0) {
        //convert and cache image
        NSString* imageString= returnData[0][@"imageString"];
        UIImage* returnImage= [self imageFromString:imageString];
        int index = [returnData[0][@"id"] intValue];
        [[ImageCache sharedCache] cacheImage:returnImage withID:index];
        return @[returnImage];
    }
    else {
        return nil;
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//post to the database the newdata item
    NSMutableDictionary * dictionary= [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%d",_imagesSizeNextImageID] forKey:@"blobPath"];
    [_dataRepository createDataItem:dictionary usingService:self withReturnBlock:_comp];
}


@end
