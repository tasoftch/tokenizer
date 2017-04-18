//
//  GeneralTokenizerFunctions.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "GeneralTokenizerFunctions.h"

bool phpkit_is_character_whitespace(unichar cc) {
	return (cc == ' ' || cc == '\t' || cc == '\n' || cc == '\r') ? true : false;
}

bool phpkit_is_character_string(unichar cc) {
	return ((cc >= 0x41 && cc <= 0x5a) || (cc >= 0x61 && cc<=0x7a)) ? true : false;
}
bool phpkit_is_character_number(unichar cc) {
	return (cc >= 0x30 && cc <= 0x39) ? true : false;
}
bool phpkit_is_character_hexnumber(unichar cc) {
	return phpkit_is_character_hexnumber_char(cc) || phpkit_is_character_number(cc) ? true : false;
}

bool phpkit_is_character_hexnumber_char(unichar cc) {
	return ((cc >= 0x41 && cc <= 0x47) || (cc >= 0x61 && cc<=0x67)) ? true : false;
}


bool isStringEqualTo(unichar *string1, unsigned length1, const char *string2, unsigned length2, bool caseInsensitive) {
	if(length1 != length2)
		return false;
	
	for(int e=0;e<length1;e++) {
		char ch = string1[e];
		if(caseInsensitive && ch != '_')
			ch |= 0b00100000;
		
		if(ch != string2[e])
			return false;
	}
	
	return true;
}


TATokenCode phpkit_get_code_of_control_character(unichar cc) {
	TATokenCode code = 0;
	switch (cc) {
		case '!': code = TA_T_EXCLAMATION_MARK; break;
		case '"': code = TA_T_ENCAPSED_AND_WHITESPACE; break;
		case '#': code = TA_T_SHARP; break;
		case '$': code = TA_T_DOLLAR; break;
		case '%': code = TA_T_PERCENT; break;
		case '&': code = TA_T_AMPERSAND; break;
		case '\'': code = TA_T_CONSTANT_ENCAPSED_STRING; break;
		case '(': code = TA_T_PARENTHESE_OPEN; break;
		case ')': code = TA_T_PARENTHESE_CLOSE; break;
		case '*': code = TA_T_ASTERISK; break;
		case '+': code = TA_T_PLUS; break;
		case ',': code = TA_T_COMMA; break;
		case '-': code = TA_T_DASH; break;
		case '.': code = TA_T_FULLSTOP; break;
		case '/': code = TA_T_SLASH; break;
		case ':': code = TA_T_COLON; break;
		case ';': code = TA_T_SEMI_COLON; break;
		case '<': code = TA_T_LESS_THAN; break;
		case '=': code = TA_T_EQUALS; break;
		case '>': code = TA_T_GREATHER_THAN; break;
		case '?': code = TA_T_QUESTION_MARK; break;
		case '@': code = TA_T_AT; break;
		case '[': code = TA_T_BRACKET_OPEN; break;
		case '\\': code = TA_T_NS_SEPARATOR; break;
		case ']': code = TA_T_BRACKET_CLOSE; break;
		case '^': code = TA_T_CIRCUMFLEX; break;
		case '_': code = TA_T_UNDERSCORE; break;
		case '`': code = TA_T_BACKTICK; break;
		case '~': code = TA_T_TILDE; break;
		case '{': code = TA_T_BLOCK_OPEN; break;
		case '|': code = TA_T_VLINE; break;
		case '}': code = TA_T_BLOCK_OPEN; break;
		default: code = TA_T_UNKNOWN; break;
	}
	return code;
}
