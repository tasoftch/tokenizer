//
//  TAToken.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TATokenNames.h"

@interface TAToken : NSObject
@property (nonatomic, assign) TATokenCode code;
@property (nonatomic, assign) TATokenLevel level;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) unsigned line;

@property (nonatomic, copy) NSString *content;

- (id)initWithCode:(TATokenCode)code
             level:(TATokenLevel)level
             range:(NSRange)range
              line:(unsigned)line
           content:(NSString *)content;
@end
