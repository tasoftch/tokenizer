//
//  TATokenNames.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	TAXMLTokenLevel			= 1<<0,
};
typedef unsigned TATokenLevel;


enum {
	// Basic Tokenizers
	TA_T_UNKNOWN					  = 0,
	
	TA_T_EXCLAMATION_MARK			  = 10,	  // !
	TA_T_SHARP						  = 11,	  // #
	TA_T_DOLLAR						  = 12,	  // $
	TA_T_PERCENT					  = 13,	  // %
	TA_T_PLUS						  = 14,	  // +
	TA_T_DASH					 	  = 15,	  // -
	TA_T_SLASH						  = 16,	  // /
	TA_T_AMPERSAND					  = 17,	  // &
	TA_T_ASTERISK					  = 18,   // *
	TA_T_COMMA						  = 19,   // ,
	TA_T_FULLSTOP					  = 20,   // .
	
	TA_T_COLON						  = 21,   // :
	TA_T_SEMI_COLON					  = 22,   // ;
	
	TA_T_LESS_THAN					  = 23,   // <
	TA_T_GREATHER_THAN				  = 24,   // >
	TA_T_EQUALS						  = 25,   // =
	
	TA_T_QUESTION_MARK				  = 26,   // ?
	TA_T_AT							  = 27,   // @
	
	TA_T_CIRCUMFLEX					  = 28,   // ^
	TA_T_UNDERSCORE					  = 29,   // _
	TA_T_BACKTICK					  = 30,   // `
	TA_T_TILDE						  = 31,   // ~
	TA_T_VLINE						  = 32,	  // |
	
	// Controls
	
	TA_T_PARENTHESE_OPEN			  = 51,  // (
	TA_T_PARENTHESE_CLOSE			  = 52,  // )
	
	TA_T_BRACKET_OPEN				  = 53,  // [
	TA_T_BRACKET_CLOSE				  = 54,  // ]
	
	TA_T_BLOCK_OPEN					  = 55,  // {
	TA_T_BLOCK_CLOSE				  = 56,  // }
	
	// XML
	
	TA_T_XML_OPEN_TAG				  = 100,	// <a-zA-Z\-0-9_(>|)
	TA_T_XML_OPEN_HEADER_TAG		  = 101, 	// <?
	TA_T_XML_HEADER_ATTRIBUTE		  = 102,
	TA_T_XML_CLOSE_HEADER_TAG		  = 103,
	TA_T_XML_ATTRIBUTE				  = 104,
	TA_T_XML_NAMESPACE				  = 105,
	TA_T_XML_CLOSE_TAG				  = 106,
	TA_T_XML_DOC_TYPE				  = 107,
	TA_T_XML_ENTITY					  = 108,
	TA_T_XML_COMMENT				  = 109,
	
	TA_T_ENCAPSED_AND_WHITESPACE			  = 322,
	TA_T_CONSTANT_ENCAPSED_STRING			  = 323,
	
	TA_T_NS_SEPARATOR				  = 390,
	
};
typedef unsigned TATokenCode;
