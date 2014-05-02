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

@interface NoteEditorViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteEditorViewController
{
    TimeIndicatorView* _timeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _timeView = [[TimeIndicatorView alloc] init:self.note.timestamp];
    [self.view addSubview:_timeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.textView.text = self.note.contents;
    self.textView.delegate = self;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)viewDidLayoutSubviews {
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
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self updateTimeIndicatorFrame];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // copy the updated note text to the underlying model.
    _note.contents = textView.text;
}

@end
