//
//  Token.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TATokenNames.h"

struct _Token {
	TATokenCode code;
	TATokenLevel level;
	NSRange range;
	unsigned line;
};
typedef struct _Token Token;

