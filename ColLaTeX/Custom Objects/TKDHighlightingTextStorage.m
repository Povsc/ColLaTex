//
//  TKDHighlightingTextStorage.m
//  ColLaTeX
//
//  Created by felipeccm on 7/28/21.
//

#import "TKDHighlightingTextStorage.h"

@implementation TKDHighlightingTextStorage

- (id)init {
    self = [super init];
    
    if (self) {
        self.imp = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return self.imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [self.imp attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self.imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self.imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing {
    // Regular expression matching all \comands -- first character \, followed by an alphabetic character
    static NSRegularExpression *backSlashExpression;
    backSlashExpression = backSlashExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\\\[\\p{Alphabetic}]*[\\p{Alphabetic}]" options:0 error:NULL];
    
    // Regex matching all $ math expressions
    static NSRegularExpression *mathExpression;
    mathExpression = mathExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\$[^\\$]+\\$" options:0 error:NULL];
    
    // Regex matching all comments
    static NSRegularExpression *commentExpression;
    commentExpression = commentExpression ?: [NSRegularExpression regularExpressionWithPattern:@"%.*" options:0 error:NULL];
    
    
    // Clear text color of edited range
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    // Find all /commands in range
    [backSlashExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        // Add red highlight color
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
    }];
    
    // Find all in-line math expressions in range
    [mathExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        // Add green highlight color
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:result.range];
    }];
    
    // Find all comments in range
    [commentExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        // Add green highlight color
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:result.range];
    }];
    
    // Set font and font size to entire document
    [self addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Rockwell" size:14] range:NSMakeRange(0, self.string.length)];
  
  // Call super after changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
  [super processEditing];
}
@end
