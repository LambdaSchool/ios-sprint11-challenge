//
//  ABCLyricsDetailViewController.m
//  LyricFinder
//
//  Created by Austin Cole on 3/1/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import "ABCLyricsSearchViewController.h"
#import "LyricsController.h"
#import "ABCSongController.h"

@interface ABCLyricsSearchViewController ()

@property NSFileManager *fileManager;
@property LyricsController *lyricsController;
@property ABCSongController *songController;
@property(nonatomic) NSString *results;

@end

@implementation ABCLyricsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lyricsController = [[LyricsController alloc] init];
    _songController = [[ABCSongController alloc] init];
    _fileManager = NSFileManager.defaultManager;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)saveButtonTapped:(id)sender {
    if (_lyricsTextView.text != nil) {
    [_fileManager createDirectoryAtURL:NSBundle.mainBundle.bundleURL withIntermediateDirectories: NO attributes: nil error: nil];
    Song *newSong = [[Song alloc] init];
        newSong.lyrics = _lyricsTextView.text;
        newSong.title = _trackTextField.text;
        newSong.artist = _artistTextField.text;
        newSong.rating = [_ratingLabel.text integerValue];
        
    }
}

- (IBAction)ratingIncrememnterSegmentedControlTapped:(id)sender {
}

- (IBAction)searchForLyricsButtonTapped:(id)sender {
    if (_artistTextField.text != nil && _trackTextField.text != nil) {
        NSBlockOperation *fetchOperation = [[NSBlockOperation alloc] init];
        NSBlockOperation *updateOperation = [[NSBlockOperation alloc] init];
        [updateOperation addExecutionBlock:^{
            [self updateViews];
        }];
        [fetchOperation addExecutionBlock:^{
            [self->_lyricsController fetchLyricsWithArtist:_artistTextField.text withTrack:_trackTextField.text withCompletionHandler:^(NSError * _Nonnull error) {
            }];
        }];
        [fetchOperation start];
        [updateOperation start];

        
    }
}

- (void)updateViews {
    _lyricsTextView.text = _lyricsController.results;
}

- (void)setResults:(NSString *)results {
    [self updateViews];
}
@end
