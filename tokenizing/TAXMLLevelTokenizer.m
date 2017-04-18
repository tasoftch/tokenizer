//
//  TAXMLLevelTokenizer.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TAXMLLevelTokenizer.h"
#import "GeneralTokenizerFunctions.h"


bool phpkit_is_valid_xml_identifier(unichar cc, TATokenCode code) {
	bool res = cc == '-' || cc == '_' || phpkit_is_character_string(cc);
	if(!res && (code == TA_T_XML_OPEN_TAG || code == TA_T_XML_OPEN_HEADER_TAG || code == TA_T_XML_ATTRIBUTE))
		res = phpkit_is_character_number(cc);
	return res;
}


@implementation TAXMLLevelTokenizer {
	int open, levelSwitch;
	bool inString, inChar, inComment, onEscape;
}

- (void)setupWithCode:(TATokenCode)code initialRange:(NSRange)range inScript:(NSString *)script {
	if(code == TA_T_XML_COMMENT) {
		NSRange end = NSMakeRange(NSMaxRange(range)-3, 3);
		if(NSMaxRange(end)<script.length && [[script substringWithRange:end] isEqualToString:@"-->"])
			return;
		inComment = true;
	}
	if(code == TA_T_ENCAPSED_AND_WHITESPACE)
		inString = true;
	if(code == TA_T_CONSTANT_ENCAPSED_STRING)
		inChar = true;
}

- (void)reset {
	levelSwitch = open = 0;
	inString = inChar = inComment = false;
	
}

- (TALevelTokenizer *)sublevelTokenizerForLevel:(TATokenLevel)level {
  // Implement for deeper tokenizers
	return self;
}



- (void)parseToken:(unichar *)token code:(TATokenCode)code range:(NSRange)range context:(TATokenizerContext *)ctx {
	
	ctx->outHandler(token, code, TAXMLTokenLevel, range);
}

- (void)tokenizeCharacter:(unichar)cc context:(TATokenizerContext *)ctx {
	if(cc == '<' && self.phpLevelTokenizer) {
		levelSwitch = 1;
		return;
	}
	
	if(levelSwitch == 1 && cc == '?') {
		MAKE_NEW_CODE(TA_T_OPEN_TAG);
		ctx->currentTokenizer = self.phpLevelTokenizer;
		ctx->appendCharacter('<');
		ctx->appendCharacter('?');
		levelSwitch = 0;
		if(open == 1)
			open = 10;
		return;
	} else if(levelSwitch == 1) {
		levelSwitch = 0;
		MAKE_NEW_CODE(TA_T_LESS_THAN);
		ctx->appendCharacter('<');
		open = 1;
	}
	
	if(onEscape) {
		onEscape = false;
		goto append;
	}
	
	if(cc == '"' && !inChar && !inComment) {
		if(inString) {
			inString= false;
		} else {
			MAKE_NEW;
			SET_CODE(TA_T_ENCAPSED_AND_WHITESPACE);
			inString= true;
		}
		goto append;
	}
	
	if(cc == '\'' && !inString && !inComment) {
		if(inChar) {
			inChar= false;
		} else {
			MAKE_NEW;
			SET_CODE(TA_T_CONSTANT_ENCAPSED_STRING);
			inChar= true;
		}
		goto append;
	}
	
	if(cc == '-' && inComment) {
		if(open == 32) {
			open = 33;
			goto append;
		}
		if(open == 33) {
			open = 34;
			goto append;
		}
	}
	if(open == 34) {
		if(cc == '>') {
			open = 0;
			inComment = false;
			goto append;
		}
		open = 32;
		goto append;
	}
	
	if(inString || inChar || inComment) {
		if(inString && ctx->tokenCode != TA_T_ENCAPSED_AND_WHITESPACE)
			MAKE_NEW_CODE(TA_T_ENCAPSED_AND_WHITESPACE);
		if(inChar && ctx->tokenCode != TA_T_CONSTANT_ENCAPSED_STRING)
			MAKE_NEW_CODE(TA_T_CONSTANT_ENCAPSED_STRING);
		if(inComment && ctx->tokenCode != TA_T_XML_COMMENT)
			MAKE_NEW_CODE(TA_T_XML_COMMENT);
		if(cc == '\\')
			onEscape = true;
		goto append;
	}
	
	if(open == 4) {
		if(cc == '>') {
			MAKE_NEW;
			SET_CODE(TA_T_XML_CLOSE_HEADER_TAG);
			ctx->appendCharacter('?');
			open = 0;
			goto append;
		}
		MAKE_NEW;
		SET_CODE(TA_T_QUESTION_MARK);
		ctx->appendCharacter('?');
		open = 3;
		goto whitespace;
	}
	
	if(open == 3) {
		if(phpkit_is_valid_xml_identifier(cc, ctx->tokenCode)) {
			MAKE_NEW_CODE(TA_T_XML_HEADER_ATTRIBUTE);
			goto append;
		}
		if(cc == '=') {
			MAKE_NEW;
			SET_CODE(TA_T_EQUALS);
			goto append;
		}
		if(cc == '?') {
			open = 4;
			return;
		}
		goto whitespace;
	}
	
	if(open == 2) {
		if(phpkit_is_valid_xml_identifier(cc, ctx->tokenCode))
			goto append;
		
		open = 3;
		goto whitespace;
	}
	
	if(open == 1) {
		if(cc == '?') {
			open = 2;
			SET_CODE(TA_T_XML_OPEN_HEADER_TAG);
			goto append;
		}
		if(phpkit_is_valid_xml_identifier(cc, ctx->tokenCode)) {
			if(IS_CODE(TA_T_XML_NAMESPACE))
				MAKE_NEW;
			SET_CODE(TA_T_XML_OPEN_TAG);
			goto append;
		}
		
		if(cc == ':') {
			SET_CODE(TA_T_XML_NAMESPACE);
			goto append;
		}
		
		if(cc == '>') {
			MAKE_NEW_CODE(TA_T_XML_OPEN_TAG);
			open = 0;
			goto append;
		}
		
		if(IS_CODE(TA_T_XML_OPEN_TAG)) {
			open = 10;
			goto onlywhite;
		}
		if(cc == '!') {
			open = 30;
			goto append;
		}
		if(cc == '/') {
			open = 40;
			goto append;
		}
		goto text;
	}
	
	if(open == 40) {
		SET_CODE(TA_T_XML_CLOSE_TAG);
		if(cc == '>')
			open = 0;
		goto append;
	}
	
	if(open == 10) {
		if(cc == '>') {
			if(IS_CODE(TA_T_SLASH))
				SET_CODE(TA_T_XML_OPEN_TAG);
			else
				MAKE_NEW_CODE(TA_T_XML_OPEN_TAG);
			open = 0;
			goto append;
		}
		
		if(phpkit_is_valid_xml_identifier(cc, ctx->tokenCode)) {
			MAKE_NEW_CODE(TA_T_XML_ATTRIBUTE);
			goto append;
		}
		
		if(cc == ':') {
			SET_CODE(TA_T_XML_NAMESPACE);
			goto append;
		}
		
		if(cc == '=') {
			MAKE_NEW;
			SET_CODE(TA_T_EQUALS);
			goto append;
		}
		
		if(phpkit_is_character_whitespace(cc)) {
			ctx->makeNewTokenWithCodeIfNeeded(TA_T_WHITESPACE);
			goto append;
		}
		MAKE_NEW;
		SET_CODE(phpkit_get_code_of_control_character(cc));
		goto append;
	}
	
	if(cc == '<') {
		open = 1;
		MAKE_NEW;
		SET_CODE(TA_T_LESS_THAN);
		goto append;
	}
	
	if(cc == '&') {
		MAKE_NEW;
		SET_CODE(TA_T_XML_ENTITY);
		open = 20;
		goto append;
	}
	
	if(open == 20) {
		if(cc == ';') {
			open = 0;
		}
		goto append;
	}
	
	if(open == 30) {
		if(cc == '-') {
			open = 31;
			goto append;
		}
		open = 35;
		goto append;
	}
	
	if(open == 31) {
		if(cc == '-') {
			open = 32;
			SET_CODE(TA_T_XML_COMMENT);
			inComment = true;
			goto append;
		}
		SET_CODE(TA_T_INLINE_HTML);
		open = 0;
		goto text;
	}
	
	if(open == 35) {
		SET_CODE(TA_T_XML_DOC_TYPE);
		if(cc == '>')
			open = 0;
		goto append;
	}
	
	goto text;
onlywhite:
	if(phpkit_is_character_whitespace(cc)) {
		ctx->makeNewTokenWithCodeIfNeeded(TA_T_WHITESPACE);
		goto append;
	}
	goto append;
whitespace:
	if(phpkit_is_character_whitespace(cc)) {
		ctx->makeNewTokenWithCodeIfNeeded(TA_T_WHITESPACE);
		goto append;
	}
text:
	ctx->makeNewTokenWithCodeIfNeeded(TA_T_INLINE_HTML);
append:
	ctx->appendCharacter(cc);
}
@end
