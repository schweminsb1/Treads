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



@class DataRepository;

@interface ImageService : NSObject <TreadsService>

typedef void (^CompletionBlock) ();


@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

@property (nonatomic,strong)NSString * SASURL;
@property (nonatomic,strong)MSTable * imageTable;

//only used in insert
@property int imagesSizeNextImageID;
@property (nonatomic,strong)CompletionBlock comp;
-(void) insertImageAsBlob:(UIImage *) image withCompletion:(CompletionBlock) ultimatecompletionblock;

-(void) getImageWithPhotoID:(int) photoid  getImageWithPhotoID:(int) photoid;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

@end
