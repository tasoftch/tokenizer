//
//  TATokenizerContext.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//
//  Helper class to tokenize over a script

#import "TATokenNames.h"

@class TALevelTokenizer;

@interface TATokenizerContext : NSObject {
@public
	// General
	TALevelTokenizer *currentTokenizer;
	
	// Parsing output
	void (^outHandler)(unichar *, TATokenCode, TATokenLevel, NSRange);
	
	
	// Tokenizing
	
	unichar *currentToken;
	unsigned tokenLength;
	
	TATokenCode tokenCode;
	
	void(^appendCharacter)(unichar);
	void(^makeNewToken)();
	void(^makeNewTokenWithCodeIfNeeded)(TATokenCode);
}

@end


#define IS_CODE(CODE) (ctx->tokenCode == CODE)
#define MAKE_NEW ctx->makeNewToken()

#define MAKE_NEW_CODE(CODE) ctx->makeNewTokenWithCodeIfNeeded(CODE)
#define SET_CODE(CODE) ctx->tokenCode = CODE

