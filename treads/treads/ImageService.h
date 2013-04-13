//
//  ImageService.h
//  treads
//
//  Created by Sam Schwemin on 4/9/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TreadsService.h"



#import "DataRepository.h"

@interface ImageService : NSObject <TreadsService>



@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

@property (nonatomic,strong)NSString * SASURL;
@property (nonatomic,strong)MSTable * imageTable;

//only used in insert
@property int imagesSizeNextImageID;
@property (nonatomic,strong)CompletionBlock comp;

-(void) insertImage:(UIImage *) image withCompletion:(MSItemBlock) ultimatecompletionblock;


-(void) getImageWithPhotoID:(int) photoid withReturnBlock:(CompletionWithItems) comp;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

@end
