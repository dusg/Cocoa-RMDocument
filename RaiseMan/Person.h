//
//  Person.h
//  RaiseMan
//
//  Created by 杜... on 2017/2/22.
//  Copyright © 2017年 杜... All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString(SortString)
-(NSComparisonResult)lengthCompare:(NSString*)str;
@end

@interface Person : NSObject <NSCoding>
{
    NSString *personName;
    float expectedRaise;
}
@property (readwrite,copy)NSString* personName;
@property (readwrite)float expectedRaise;
-(NSComparisonResult) lengthCompare:(id) str;
@end
