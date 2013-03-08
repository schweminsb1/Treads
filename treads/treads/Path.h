//
//  Path.h
//  lecture11
//
//  Created by Joshua Gretz on 3/5/13.
//  Copyright (c) 2013 gcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Path : NSObject

+(NSString*) bundle;
+(NSString*) subBundle: (NSString*) subPath;

+(NSString*) documentDirectory;
+(NSString*) subDocumentDirectory: (NSString*) subPath;

+(NSString*) libraryDirectory;
+(NSString*) subLibraryDirectory: (NSString*) subPath;

+(NSString*) subLibraryCachesDirectory: (NSString*) subPath;

@end
