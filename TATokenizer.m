//
//  TATokenizer.m
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TATokenizer.h"
#import "BasicTokenizer.h"

@implementation TATokenizer {
	TALevelTokenizer *_levelTokenizer;
}

- (void)setLevelTokenizer:(TALevelTokenizer *)levelTokenizer {
	_levelTokenizer = levelTokenizer;
}

- (TALevelTokenizer *)levelTokenizer {
	if(!_levelTokenizer) {
		_levelTokenizer = [TALevelTokenizer new];
	}
	return _levelTokenizer;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.allowWhitespaceTokens = YES;
	}
	return self;
}
- (NSArray *)tokenizeString:(NSString *)script {
	return [self tokenizeString:script range:NSMakeRange(0, script.length)];
}

- (NSArray *)tokenizeString:(NSString *)script range:(NSRange)range {
	NSMutableArray *tokens = [NSMutableArray array];
	[self tokenizeString:script range:range tokenHandler:^(TAToken *token) {
		if(token)
			[tokens addObject:token];
	}];
	
	return tokens;
}

- (void)tokenizeString:(NSString *)script range:(NSRange)range tokenHandler:(void (^)(TAToken *))handler {
	NSAssert(handler != nil, @"Token Handler must not be nil.");
	[self tokenizeString:script range:range rawTokenHandler:^(struct _Token token, unichar *content) {
		TAToken *tk = [[TAToken alloc] initWithCode:token.code level:token.level range:token.range line:token.line content:self.allowLazyTokens ? nil : [NSString stringWithCharacters:content length:token.range.length]];
		handler(tk);
	}];
}

- (void)tokenizeString:(NSString *)script range:(NSRange)range rawTokenHandler:(void(^)(struct _Token, unichar *))handler {
	NSAssert(handler != nil, @"Token Handler must not be nil.");
	
	unichar buffer[range.length];
	[script getCharacters:buffer range:range];
	
	[self.levelTokenizer reset];
	[self.levelTokenizer setupWithCode:self.initialTokenCode initialRange:self.initialTokenRange inScript:script];
	
	int options = 0;
	if(self.allowWhitespaceTokens)
		options |= 1;
	
	phpkit_basic_tokenize(buffer, (unsigned)range.length, self.levelTokenizer, options, ^(struct _Token token, unichar *content, unsigned int length) {
		handler(token, content);
	});
}
@end
