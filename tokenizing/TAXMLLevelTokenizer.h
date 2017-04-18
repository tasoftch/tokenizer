//
//  TAXMLLevelTokenizer.h
//  PHPKit_2017
//
//  Created by Thomas Abplanalp on 13.04.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TALevelTokenizer.h"

@interface TAXMLLevelTokenizer : TALevelTokenizer
@property (nonatomic, strong) TALevelTokenizer *phpLevelTokenizer;
@property (nonatomic, strong) TALevelTokenizer *cssLevelTokenizer;
@property (nonatomic, strong) TALevelTokenizer *jsLevelTokenizer;
@end
