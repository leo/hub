# github

An iOS client for GitHub. Tab bar icon width: 20px

## Contributing

1. Sign up for [GitHub's Developer Program](https://developer.github.com/program/), register a new application [here](https://github.com/settings/developers) and make sure that the "Authorization callback URL" is "github://authenticated". The name and the other details aren't important.

2. Once the temporary application has been registered, [fork](https://help.github.com/articles/fork-a-repo/) this repository to your own GitHub account and then [clone](https://help.github.com/articles/cloning-a-repository/) it to your local device.

3. After that, [install Xcode](https://itunes.apple.com/en/app/xcode/id497799835?l=en&mt=12) from the App Store.

4. Now that Xcode is fully installed and the repository cloned to your device, please double-click on the "*.xcodeproj" file to open the project in Xcode.

5. Once it's open, immediately create a new file called "Keys.xcconfig" in the root directory. It should look similar to this and hold the keys of the temporary application you've registered in GitHub's web interface (make sure to replace the values surrounded by "<" and ">" with the actualy keys):

```swift
//
//  Keys.xcconfig
//  GitHub
//
//  Created by Leo Lamprecht on 09/06/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

GITHUB_CLIENT_ID = <your-applications-client-id>
GITHUB_CLIENT_SECRET = <your-applications-client-secret>
```

After changing the values and saving the file, you can start making changes!
