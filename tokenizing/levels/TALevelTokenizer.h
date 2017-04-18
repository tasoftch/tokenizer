//
//  TALevelTokenizer.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TATokenizerContext.h"
#import "Token.h"

@interface TALevelTokenizer : NSObject
@property (nonatomic, weak) TALevelTokenizer *parentTokenizer;

- (void)reset;
- (void)setupWithCode:(TATokenCode)code initialRange:(NSRange)range inScript:(NSString *)script;

- (void)finishTokenizing;
- (void)tokenizeCharacter:(unichar)cc context:(TATokenizerContext *)ctx;
- (void)parseToken:(unichar *)token code:(TATokenCode)code range:(NSRange)range context:(TATokenizerContext *)ctx;


- (TALevelTokenizer *)sublevelTokenizerForLevel:(TATokenLevel)level;


// The default implementation selects the edited line
- (NSRange)invalidatedRangeByModifyingCharacters:(NSRange)range
										ofScript:(NSString *)script
									  withString:(NSString *)string
								  knownTokenCode:(TATokenCode)code;
@end
