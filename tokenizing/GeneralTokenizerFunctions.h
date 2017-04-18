//
//  GeneralTokenizerFunctions.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import <PHPKit/TATokenNames.h>

bool phpkit_is_character_whitespace(unichar cc);
bool phpkit_is_character_string(unichar cc);

bool phpkit_is_character_number(unichar cc);
bool phpkit_is_character_hexnumber(unichar cc);

bool phpkit_is_character_hexnumber_char(unichar cc);

TATokenCode phpkit_get_code_of_control_character(unichar cc);

bool isStringEqualTo(unichar *string1, unsigned length1, const char *string2, unsigned length2, bool caseInsensitive);

