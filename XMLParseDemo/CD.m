//
//  CD.m
//  XMLParseDemo
//
//  Created by Amay on 10/28/15.
//  Copyright © 2015 Beddup. All rights reserved.
//

#import "CD.h"

@implementation CD

-(NSString *)description{

    return [NSString stringWithFormat:@"title:%@\n artist:%@ \n country:%@ \n company:%@ \n price:%@ \n year:%@ \n",self.title,self.artist,self.country,self.company,self.price,self.year];
}

@end
