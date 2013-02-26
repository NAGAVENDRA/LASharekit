LASharekit
==========

[Luis Ascorbe](http://about.me/lascorbe)

Tweet me [@LuisEAM](http://twitter.com/luiseam)

`LASharekit` automatically share to facebook, twitter, pinterest or by email. With an extra to save images to cameraroll and copy to the pasteboard.

Of course, I'll love to hear your using my control in your app, you can contact me (<devlascorbe@gmail.com>) anytime

![Screenshot of LASharekit](https://raw.github.com/Lascorbe/LASharekit/master/captura.png  "LASharekit Screenshot")

Example
==========
Build and run the `LASharekitExample` project in Xcode to see `LASharekit` in action.


Requeriments
==========

LASharekit can be used in iOS5 and iOS6. Work with ARC and non-ARC projects.

· Xcode 4.5 or higher

· Apple LLVM compiler

· iOS 5.0 or higher

Instructions
==========

Just drag and drop the project files to your project, then add the following libraries:

iOS5:
- FacebookSDK.framework (from facebook) -> https://developers.facebook.com/ios/

  · AdSupport.framework

  · libsqlite3.dylib

- Twitter.framework

iOS6:
- Accounts.framework 
- Social.framework 

Common:
- MessageUI.framework

REComposeViewController:
- QuartzCore.framework 

Reachability:
- SystemConfiguration.framework 


Using facebook in iOS5:

* You must create a facebook app in [their site](https://developers.facebook.com/apps).
* Then add the `FacebookAppID` to the `info.plist` file.
* Add the URLScheme too (it's like `fbYOUR_FACEBOOKAPPID`).
* Configure the AppDelegate to work with the FacebookSDK (in the example you can see this).

Note: If you are not using ARC in your project, add `-fobjc-arc` as a compiler flag for the `REComposeViewController` classes.

Usage
==========

* Init with completion blocks (the @parameter passed in the init method is the target to show the modals)

``` objective-c
    laSharekit = [[LASharekit alloc] init:self];
    
    // set completion blocks
    [laSharekit setCompletionDone:^{
        // Do something when done
    }];
    [laSharekit setCompletionCanceled:^{
        // Do something when canceled
    }];
    [laSharekit setCompletionFailed:^{
        // Do something when failed
    }];
    [laSharekit setCompletionSaved:^{
        // Do something when saved
    }];
```


* Set the properties and call to action

``` objective-c
    // set the variables
    laSharekit.title    = @"Some title";
    laSharekit.url      = [NSURL URLWithString:@"https://github.com/Lascorbe/LASharekit"];
    laSharekit.text     = @"Some text";
    laSharekit.imageUrl = [NSURL URLWithString:@"https://github.com/Lascorbe/LASharekit/image"];
    laSharekit.image    = imageView.image; // some UIImage

    // call the action
    [laSharekit tweetIt];
```


Actions
==========
``` objective-c
- (void) facebookPost;                  // Post to FACEBOOK
- (void) tweet;                         // Tweet
- (void) follow:(NSString *)screenName  // follow someone in twitter
- (void) pinIt;                         // Pin it (PINTEREST)
- (void) emailIt;                       // EMAIL It
- (void) saveImage;                     // SAVE IMAGE TO CAMERAROLL

- (void) copyTitleToPasteboard;         // COPY THE TITLE TO THE PASTEBOARD
- (void) copyTextToPasteboard;          // COPY THE TEXT TO THE PASTEBOARD
- (void) copyUrlToPasteboard;           // COPY THE URL TO THE PASTEBOARD
- (void) copyImageToPasteboard;         // COPY THE IMAGE TO THE PASTEBOARD
- (void) copyImageUrlToPasteboard;      // COPY THE IMAGEURL TO THE PASTEBOARD
```

Known Issues
==========
The FacebookSDK 3.1 don't work with the simulator in iOS6 (problems with the `FacebookAppID`).


Credits
==========

Matej Bukovinski creator of [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

Red Davis creator of [RDActionSheet](https://github.com/reddavis/RDActionSheet)

Roman Efimov creator of [REComposeViewController](https://github.com/romaonthego/REComposeViewController)


License
=======

`LASharekit` is distributed under the terms and conditions of the MIT license. 

Copyright (c) 2012 Luis Ascorbe

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
