//
//  BasicTokenizer.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "Token.h"

@class TALevelTokenizer;

#define MaxTokenBuffer 1000

void phpkit_basic_tokenize(
	unichar *script,
	unsigned length,
	TALevelTokenizer *initialTokenizer,
	int options,
	void(^outHandler)(struct _Token token, unichar *content, unsigned length)
);

typedef struct {
	unichar *string;
	unsigned length;
} phpkit_string;

phpkit_string *phpkit_alloc_string(unichar *string, unsigned length);
void phpkit_string_release(phpkit_string *str);
void phpkit_string_reset(phpkit_string *original);
void phpkit_string_append_chars(phpkit_string *original, unichar *buffer, unsigned length);
