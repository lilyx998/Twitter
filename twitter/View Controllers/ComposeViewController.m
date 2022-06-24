//
//  ComposeViewController.m
//  twitter
//
//  Created by Lily Yang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    // Do any additional setup after loading the view.
}

- (IBAction)tweetAction:(id)sender {
    [[APIManager shared]postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// shouldChangeTextInRange is called every
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 280;
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(newText.length <= characterLimit){
        NSInteger remaining = 280 - newText.length;
        self.charactersRemainingLabel.text = [@(remaining) stringValue];
        [self.charactersRemainingLabel setTextColor:[UIColor colorWithDisplayP3Red:0 green:0.5 blue:0.194 alpha:100]];
        if(remaining == 0)
           [self.charactersRemainingLabel setTextColor:[UIColor redColor]];
    }
    
    return newText.length <= characterLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
