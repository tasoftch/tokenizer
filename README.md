# Tokenizer
Tokenizing concept in Objc for several languages.<br>
Including a test tokenizer for xml.<br>
Generates tokens for script<br>
````xml
<element attribute="test">
  Text
</element>
````
Similar as: XML_OPEN_TAG, XML_ATTRIBUTE, GENERAL_EQUALS, GENERAL_STRING, XML_OPEN_TAG, GENERAL_INLINE_TEXT, XML_CLOSE_TAG

## TATokenizer
The general tokenizer represents a "wrapper" of level tokenizers.<br>
Levels are different code blocks such as HTML, but HTML can contain<br>
CSS or Javascript or anytime PHP. These parts can be tokenized by<br>
different level tokenizers.
The TATokenizer class prepares the levels and manage the script<br>
and token creation.

## Level Tokenizing
I use level tokenizing because it's better to split the code into smaller peaces.<br>
Level tokenizing allows you to create custom tokenizers and include them<br>
into the tokenizing process.<br>
This example has two level tokenizers:<br>
A default tokenizer and <br>
a XML level tokenizer.
## Usage
It is very simple to use. Just create a tokenizer object and the first level tokenizer.
````objc
TATokenizer *tk = [TATokenizer new];
TALevelTokenizer *xml = [TAXMLLevelTokenizer new];
tk.levelTokenizer = xml;

NSArray *tokens = [tk tokenizeScript:@"<element attribute=\"string\">Test</element>"];
````
Now this tokenizer is ready to tokenize XML data.
