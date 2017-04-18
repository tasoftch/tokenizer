//
//  TALevelTokenizer.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TALevelTokenizer.h"
#import "GeneralTokenizerFunctions.h"

@implementation TALevelTokenizer
- (void)tokenizeCharacter:(unichar)cc context:(TATokenizerContext *)ctx {
	if(phpkit_is_character_whitespace(cc)) {
		ctx->makeNewTokenWithCodeIfNeeded(TA_T_WHITESPACE);
		goto append;
	}
	
	if(phpkit_is_character_string(cc) ) {
		ctx->makeNewTokenWithCodeIfNeeded(TA_T_STRING);
		goto append;
	}
	
	if(phpkit_is_character_number(cc)) {
		ctx->makeNewTokenWithCodeIfNeeded(TA_T_LNUMBER);
		goto append;
	}
	
	
	ctx->makeNewToken();
	ctx->tokenCode = phpkit_get_code_of_control_character(cc);
append:
	ctx->appendCharacter(cc);
}

- (void)parseToken:(unichar *)token code:(TATokenCode)code range:(NSRange)range context:(TATokenizerContext *)ctx {
	ctx->outHandler(token, code, 0, range);
}

- (void)finishTokenizing {
}
- (void)reset {}
- (void)setupWithCode:(TATokenCode)code initialRange:(NSRange)range inScript:(NSString *)script {}
- (TALevelTokenizer *)sublevelTokenizerForLevel:(TATokenLevel)level { return nil; }


- (NSRange)invalidatedRangeByModifyingCharacters:(NSRange)range
										ofScript:(NSString *)script
									  withString:(NSString *)string
								  knownTokenCode:(TATokenCode)code {
	NSUInteger start = range.location, end = NSMaxRange(range);
	
	if(start>0) {
		for(NSUInteger idx = range.location-1;YES;idx--) {
			if(idx == 0) {
				start = 0;
				break;
			}
			unichar cc = [script characterAtIndex:idx];
			
			if(cc == '\n' || cc == '\r') {
				start = idx+1;
				break;
			}
		}
	}
	
	for(NSUInteger idx=NSMaxRange(range);idx<script.length;idx++) {
		unichar cc = [script characterAtIndex:idx];
		
		if(cc == '\n' || cc == '\r') {
			end = idx+1;
			break;
		}
		if(end+1<script.length)
			end++;
		else {
			end = script.length;
			break;
		}
	}
	
	return NSMakeRange(start, end-start+string.length);
}
@end
