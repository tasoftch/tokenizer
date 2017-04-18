//
//  BasicTokenizer.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "BasicTokenizer.h"
#import "TATokenizerContext.h"
#import "TALevelTokenizer.h"

void phpkit_basic_tokenize(
  unichar *script,
  unsigned length,
  TALevelTokenizer *initialTokenizer,
  int options,
  void(^outHandler)(struct _Token token, unichar *content, unsigned length)
){
	__block struct _CharBuffer {
		unichar tokenBuffer[MaxTokenBuffer];
	} charBuffer;
	
	__block unsigned tokenBufferLength = 0;
	
	__block unsigned idx = 0;
	
	__block TATokenizerContext *ctx = [TATokenizerContext new];
	ctx->currentTokenizer = initialTokenizer;
	
	__block phpkit_string *currentString = phpkit_alloc_string(charBuffer.tokenBuffer, 0);
	
	__block unsigned line = 1;
	
	ctx->outHandler = ^(unichar *string, TATokenCode code, TATokenLevel level, NSRange range) {
		Token tk;
		tk.code = code;
		tk.level = level;
		tk.range = range;
		tk.line = line;
		outHandler(tk, string, (unsigned)range.length);
	};
	
	void(^appendCharacter)(unichar) = ^(unichar cc) {
		if(tokenBufferLength>=MaxTokenBuffer) {
			if(currentString == NULL)
				currentString = phpkit_alloc_string(charBuffer.tokenBuffer, tokenBufferLength);
			else
				phpkit_string_append_chars(currentString, charBuffer.tokenBuffer, tokenBufferLength);
			tokenBufferLength = 0;
		}
		charBuffer.tokenBuffer[ tokenBufferLength++ ] = cc;
		ctx->currentToken = charBuffer.tokenBuffer;
		ctx->tokenLength =tokenBufferLength;
	};
	ctx->appendCharacter = appendCharacter;
	
	void(^makeNewToken)() = ^{
		if(currentString->length+tokenBufferLength < 1)
			return;
		unichar *string = NULL;
		unsigned length = 0;
		
		if(currentString->length) {
			phpkit_string_append_chars(currentString, charBuffer.tokenBuffer, tokenBufferLength);
			string = currentString->string;
			length = currentString->length;
		} else {
			string = charBuffer.tokenBuffer;
			length = tokenBufferLength;
		}
		
		tokenBufferLength = 0;
		if(options & 1 && ctx->tokenCode == TA_T_WHITESPACE) {
		}
		else {
			if(!ctx->currentTokenizer) {
				ctx->outHandler(string, ctx->tokenCode, 0, NSMakeRange(idx-length, length));
				phpkit_string_reset(currentString);
				return;
			}
			[ctx->currentTokenizer parseToken:string code:ctx->tokenCode range:NSMakeRange(idx-length, length) context:ctx];
		}
		phpkit_string_reset(currentString);
	};
	
	ctx->makeNewToken = makeNewToken;
	
	void(^makeNewIfNeeded)(TATokenCode) = ^(TATokenCode code) {
		if(ctx->tokenCode != code) {
			ctx->makeNewToken();
			ctx->tokenCode = code;
		}
	};
	ctx->makeNewTokenWithCodeIfNeeded =makeNewIfNeeded;
	
	for(idx=0;idx<length;idx++) {
		unichar cc = script[idx];
		
		if(ctx->currentTokenizer) {
			[ctx->currentTokenizer tokenizeCharacter:cc context:ctx];
		}
		if(cc == '\n' || cc == '\r')
			line++;
	}
	
	ctx->makeNewToken();
	[ctx->currentTokenizer finishTokenizing];
}





phpkit_string *phpkit_alloc_string(unichar *string, unsigned length) {
	phpkit_string *str = malloc(sizeof(phpkit_string));
	str->length = length;
	str->string = malloc(sizeof(unichar)*length);
	for(unsigned e=0;e<length;e++) {
		str->string[ e ] = string[e];
	}
	return str;
}

void phpkit_string_release(phpkit_string *str) {
	free(str->string);
	free(str);
}

void phpkit_string_append_chars(phpkit_string *original, unichar *buffer, unsigned length) {
	unichar *newString = malloc(sizeof(unichar)*original->length + sizeof(unichar)*length);
	
	for(unsigned e=0;e<original->length;e++) {
		newString[ e ] = original->string[e];
	}
	for(unsigned e=0;e<length;e++) {
		newString[ original->length + e ] = buffer[e];
	}
	
	if(original->string)
		free(original->string);
	original->string = newString;
	original->length+=length;
}

void phpkit_string_reset(phpkit_string *original) {
	if(original->string)
		free(original->string);
	original->string = NULL;
	original->length = 0;
}
