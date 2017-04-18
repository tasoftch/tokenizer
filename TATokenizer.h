//
//  TATokenizer.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TAToken.h"
#import "TALevelTokenizer.h"



@interface TATokenizer : NSObject
// Should always be the first level tokenizer for a given script
@property (nonatomic, strong) TALevelTokenizer *levelTokenizer;

// if set, the methods -tokenizeString: -tokenizeString:range and
// tokenizeString:range:tokenHandler: will create tokens without content.
// This can be helpful for only colorizing a script.
@property (nonatomic, assign) BOOL allowLazyTokens;

// if set, the tokenizer will register whitespace tokens.
@property (nonatomic, assign) BOOL allowWhitespaceTokens;

// Can be used, if the tokenizer should tokenize only a part of a script.
@property (nonatomic, assign) TATokenCode initialTokenCode;
@property (nonatomic, assign) NSRange initialTokenRange;


- (NSArray *)tokenizeString:(NSString *)script;
- (NSArray *)tokenizeString:(NSString *)script range:(NSRange)range;

- (void)tokenizeString:(NSString *)script range:(NSRange)range tokenHandler:(void(^)(TAToken *token))handler;
- (void)tokenizeString:(NSString *)script range:(NSRange)range rawTokenHandler:(void(^)(struct _Token, unichar *content))handler;
@end
