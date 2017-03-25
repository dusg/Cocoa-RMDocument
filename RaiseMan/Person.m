//
//  Person.m
//  RaiseMan
//
//  Created by 杜... on 2017/2/22.
//  Copyright © 2017年 杜... All rights reserved.
//

#import "Person.h"

@implementation NSString(SortString)

-(NSComparisonResult)lengthCompare:(NSString*)str
{
    if([self length] < [str length]) {
        return NSOrderedAscending;
    } else if([self length] == [str length]) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

@end

@implementation Person
@synthesize personName;
@synthesize expectedRaise;

-(id)init
{
    self = [super init];
    if(self) {
        expectedRaise = 0.05;
        personName = @"New Person";
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:personName forKey:@"personName"];
    [aCoder encodeFloat:expectedRaise forKey:@"expectedRaise"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        personName = [aDecoder decodeObjectForKey:@"personName"];
        expectedRaise = [aDecoder decodeFloatForKey:@"expectedRaise"];
    }
    return self;
}

-(NSComparisonResult)lengthCompare:(id)str
{
    if([self.personName length] < [[str personName] length]) {
        return NSOrderedAscending;
    } else if([self.personName length] == [[str personName ] length]) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

-(void)setNilValueForKey:(NSString *)key
{
    if([key isEqualToString:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    } else {
        [super setNilValueForKey:key];
    }
}
@end
