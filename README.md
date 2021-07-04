# macOS Virtual Machine
A ARM macOS Virtual Machine, using macOS 12's new Virtualization framework.  
I copied KhaosT's code from [here](https://gist.github.com/KhaosT/fb0499130bbfcb5754d2174e78cb68b9), all I did is change some path, add some entitlements and add a simple GUI. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I successfully created a macOS 12 Virtual Machine!<br>Thanks <a href="https://twitter.com/KhaosT?ref_src=twsrc%5Etfw">@KhaosT</a> for sharing his code, he make this possible. <a href="https://t.co/nDD5IMzhlb">pic.twitter.com/nDD5IMzhlb</a></p>&mdash; Ming Chang (@mingchang137) <a href="https://twitter.com/mingchang137/status/1409821979071315970?ref_src=twsrc%5Etfw">June 29, 2021</a></blockquote>

<img width="1280" alt="Screen Shot 2021-06-30 at 3 04 50 PM" src="https://user-images.githubusercontent.com/15919723/123920979-1df98100-d9b9-11eb-8677-a9f2153a90d6.png">

### Requirements
- Apple Silicon Mac (running macOS 12)
- Xcode 13
- Apple Configurator 2
- macOS 12 IPSW
- a empty dmg image (This will be your system storage, name it disk.dmg, you can create it from Disk Utility)

### First Time Setup

1. Clone this project  
2. Run (This project works on my Mac but might not run on yours)   
3. Quit the app when "Virtual Machine" window showed up, move disk.dmg into the app's container
4. Run it again  
5. Open Apple Configurator 2, if everything works, There should have a VirtualMac in DFU mode  
6. Temporary disable macOS Firewall and iCloud Private Relay (Apple Configurator 2 can't restore VM with those features enabled)  
7. Drag macOS 12 IPSW file into Apple Configurator 2, click Restore to install macOS  
8. When it's done, you should see a purple window greeting to you. Bon Appétit!  

### It's not working / Apple Configurator 2 keeps failing!

Try removing aux.img in the app's container, restart the app and using "Start Virtual Machine Manually" function in the menu bar before restoring.  

Special thanks to [KhaosT](https://github.com/KhaosT), his code make this possible, here is the [project](https://github.com/KhaosT/MacVM) made by him, provides better GUI.
