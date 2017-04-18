//
//  TAToken.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TAToken.h"

@implementation TAToken

- (id)initWithCode:(TATokenCode)code
             level:(TATokenLevel)level
             range:(NSRange)range
              line:(unsigned int)line
           content:(NSString *)content {
	self = [self init];
	if(self) {
		self.code = code;
		self.level = level;
		self.range = range;
		self.content = content;
		self.line = line;
	}
	return self;
}
@end
