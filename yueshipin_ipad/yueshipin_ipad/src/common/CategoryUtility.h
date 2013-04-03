//
//  CategoryUtility.h
//  yueshipin
//
//  Created by joyplus1 on 13-4-3.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryUtility : NSObject

+ (NSArray *)getComicHighlightCategory;
+ (NSArray *)getComicCategory;
+ (NSArray *)getComicYearType;
+ (NSArray *)getComicRegionType;

+ (NSArray *)getMovieHighlightCategory;
+ (NSArray *)getMovieCategory;
+ (NSArray *)getMovieYearType;
+ (NSArray *)getMovieRegionType;

+ (NSArray *)getDramaHighlightCategory;
+ (NSArray *)getDramaCategory;
+ (NSArray *)getDramaYearType;
+ (NSArray *)getDramaRegionType;

+ (NSArray *)getShowHighlightCategory;
+ (NSArray *)getShowCategory;
+ (NSArray *)getShowYearType;
+ (NSArray *)getShowRegionType;
@end
