A series of scripts to help manage folders in directories.  these are primarily made for comyui - but they can pretty easily be readjusted for any windows folder directory.
these are in powershell for now.

USAGE
put any of these into directory (custom nodes) folder
go to the navigation bar at the top (windows) - type POWERSHELL 
  alternatively open powershell terminal and navigate to the folder directory
run the script (if you type part of the word and hit TAB, windows should cycle through all the matching scripts in your folder)

GitPullAll -
Basically cycles through every subdirectory and runs `git pull`.  this will update EVERY node you have in comfyui.

GitPullExclude -
same as GitPullAll - but first gives you the option to exclude any nodes/folders.  i generally recommend this one.  it's generally a bad idea to blindly go update every node (unless you only have like 1-2 and are just using a fresh install).  If, like most, you have 10-20 nodes... you're asking for a world of headaches just blindly updating everything.

GitPullNormalized -
this allows you see all your folders (comfyui nodes), does a wildcard search to make the nodes easy to read, and then let's you decide which ones you want to update.  I'd also recommend this one strongly.  Be aware this doesn't take multi input for now.... as it's intended for one by one updates.  I have it asking you a series of questions to confirm you want to update the right folder/node... but after you type a number in to find the right node, you can just hit `ENTER` a few times to accept the defaults confirming execution; and it'll update the node with a `git pull`.

Note : you can also just open them in the `RAW` and copy the script into your own txt file, then rename the folder path (if you don't like randomly downloading files off random github repos).
