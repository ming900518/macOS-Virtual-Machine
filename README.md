# macOS Virtual Machine
A ARM macOS Virtual Machine, using macOS 12's new Virtualization framework.  
I copied KhaosT's code from [here](https://gist.github.com/KhaosT/fb0499130bbfcb5754d2174e78cb68b9), all I did is change some path, add some entitlements and add a simple GUI. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I successfully created a macOS 12 Virtual Machine!<br>Thanks <a href="https://twitter.com/KhaosT?ref_src=twsrc%5Etfw">@KhaosT</a> for sharing his code, he make this possible. <a href="https://t.co/nDD5IMzhlb">pic.twitter.com/nDD5IMzhlb</a></p>&mdash; Ming Chang (@mingchang137) <a href="https://twitter.com/mingchang137/status/1409821979071315970?ref_src=twsrc%5Etfw">June 29, 2021</a></blockquote>

### How to use this

**Requirements: Apple Silicon Mac (running macOS 12), macOS 12 Beta IPSW, Xcode 13, Apple Configurator 2 and a empty dmg image(This will be your system storage)**

1. Clone this project
2. Open ViewController and replace all file path
3. Run and Debug (This project works on my Mac but might not run on yours)
4. Click macOS Virtual Machine -> Start Virtual Machine
5. Open Apple Configurator 2
6. If everything works, There should have a VirtualMac in DFU mode, drag ipsw file into Apple Configurator 2 and click Restore
7. About less than half hour, you should see a purple window greeting to you.

Bon Appétit!

Special thanks to [KhaosT](https://github.com/KhaosT), his code make this possible.
