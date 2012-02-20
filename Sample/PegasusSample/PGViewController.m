//
//  PGViewController.m
//  PegasusSample
//
//  Copyright 2012 Jonathan Ellis
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "PGViewController.h"

@implementation PGViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    int sample = 1; // *** change this to 2, 3 or 4 for other samples ***
    
    // Here, we load the XML file (from the UI group):
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"sample%d.xml", sample]];
    PGView *pegasusView = [PGView viewWithContentsOfFile:filePath];

    [self.view addSubview:pegasusView.view]; // pegasusView.view is the actual underlying UIView view
    
    if (sample == 1) {
        // We will now show how you can dynamically alter the view at runtime. We will change the image and then
        // change the text "dinosaur" to "soldier" in the prompt (comment this out to see the original view).
        
        // Start by changing the picture
        UIImageView *pictureView = (UIImageView *)[pegasusView findViewWithID:@"picture"]; // Find the view tagged with "picture". (Notice how a normal UIImageView is returned.)
        UIImage *newImage = [UIImage imageNamed:@"soldier.png"];
        pictureView.image = newImage;
        // We also need to resize the image view for the new image:
        CGRect frame = pictureView.frame;
        frame.size = newImage.size;
        pictureView.frame = frame;

        // And now we change the label text:
        UILabel *promptLabel = (UILabel *)[pegasusView findViewWithID:@"prompt"];
        promptLabel.text = [promptLabel.text stringByReplacingOccurrencesOfString:@"dinosaur" withString:@"soldier"];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
