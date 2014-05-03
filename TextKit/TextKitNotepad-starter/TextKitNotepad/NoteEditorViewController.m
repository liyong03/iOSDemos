//
//  CENoteEditorControllerViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "Note.h"
#import "TimeIndicatorView.h"
#import "SyntaxHighlightTextStorage.h"

@interface NoteEditorViewController () <UITextViewDelegate>

@end

@implementation NoteEditorViewController
{
    TimeIndicatorView* _timeView;
    SyntaxHighlightTextStorage* _textStorage;
    UITextView* _textView;
    CGSize _keyboardSize;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTextView];
    
    _timeView = [[TimeIndicatorView alloc] init:self.note.timestamp];
    [self.view addSubview:_timeView];
    _textView.scrollEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
    
}

- (void)createTextView {
    NSDictionary* attrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:_note.contents
                                      attributes:attrs];
    _textStorage = [[SyntaxHighlightTextStorage alloc] init];
    [_textStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = self.view.bounds;
    NSLayoutManager* layoutManager = [[NSLayoutManager alloc] init];
    
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width, CGFLOAT_MAX);
    NSTextContainer* container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect textContainer:container];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}

- (void)viewDidLayoutSubviews {
    _textView.frame = self.view.bounds;
    [self updateTimeIndicatorFrame];
}

- (void)updateTimeIndicatorFrame {
    [_timeView updateSize];
    _timeView.frame = CGRectOffset(_timeView.frame,
                                   self.view.frame.size.width - _timeView.frame.size.width, 0.0);
    UIBezierPath* exclusionPath = [_timeView curvePathWithOrigin:_timeView.center];
    _textView.textContainer.exclusionPaths  = @[exclusionPath];
}

- (void)preferredContentSizeChanged:(NSNotification*)notification {
    //_textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [_textStorage update];
    [self updateTimeIndicatorFrame];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // copy the updated note text to the underlying model.
    _note.contents = textView.text;
}

- (void)keyboardDidShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    _keyboardSize = [[userInfo
                      objectForKey:UIKeyboardFrameBeginUserInfoKey]
                     CGRectValue].size;
    [self updateTextViewSize];
}

- (void)keyboardDidHide:(NSNotification *)nsNotification {
    _keyboardSize = CGSizeMake(0.0, 0.0);
    [self updateTextViewSize];
}

- (void)updateTextViewSize {
    UIInterfaceOrientation orientation =
    [UIApplication sharedApplication].statusBarOrientation;
    CGFloat keyboardHeight =
    UIInterfaceOrientationIsLandscape(orientation) ?
    _keyboardSize.width : _keyboardSize.height;
    
    _textView.frame = CGRectMake(0, 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height - keyboardHeight);
}

@end
