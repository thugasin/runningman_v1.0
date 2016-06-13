//
//  BounceButtonView.m
//  BounceButtonExample
//
//  Created by Agus Soedibjo on 28/3/14.
//  Copyright (c) 2014 Agus Soedibjo. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BounceButtonView.h"
#import "PacManMainGameViewController.h"

@implementation BounceButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

    }
    return self;
}

-(IBAction)OnMenuItem1ButtonClicked:(id)sender
{
    [(PacManMainGameViewController*)m_gameViewController MenuTouchedAction:1];
}
-(IBAction)OnMenuItem2ButtonClicked:(id)sender
{
    [(PacManMainGameViewController*)m_gameViewController MenuTouchedAction:2];
}
-(IBAction)OnMenuItem3ButtonClicked:(id)sender
{
    [(PacManMainGameViewController*)m_gameViewController MenuTouchedAction:3];
}

-(void)SetController:(id)gameViewController
{
    m_gameViewController = gameViewController;
}


@end
