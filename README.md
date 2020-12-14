# Magic Media

Magic Media is a native iOS/iPadOS application that focuses on augmenting physical forms of media such as magazines, dollar bills, instruction manuals, etc. It delivers its users various options to interact with several sections of the physical media with images/text and then convert them into videos or 3D models specifically. This will help the user understand the information better in various ways of interaction, which is majorly made possible by AR. It also supports voice commands to help the user navigate through the app and have a more friendly and immersive experience.

<p align="center">
  <img src="https://github.com/ivedants/MagicMedia/blob/main/Image%203.gif" />
</p>

**Made Using**

1. Xcode 12
2. Swift 5 
3. ARKit
4. SceneKit
5. RealityKit
6. Apple Speech Framework

**Award**

This project won the Best Project (Public Choice) Award under the Augmented Reality Projects category at the Festival of Animation - Fall 2020 at The George Washington University, Washington D.C., USA.

## Table of Contents

- [Getting Started](#getting-started)
- [AR Application Design](#AR-application-design)
  - [App triggering AR](#app-triggering-ar)
  - [Combines real and virtual worlds to deliver a wholesome experience](#combines-real-and-virtual-worlds-to-deliver-a-wholesome-experience)

## Getting Started

**User Guidelines - Simple instructions about how to install the app and enjoy the AR experience**

This will help you to easily install and enjoy the app on your supported iOS/iPadOS device(s).

**Testing details:**

The app has been tested with iPhone 12 Pro Max and iPad Pro (2020, 4th generation). The recommended iOS version is iOS 14.1 but the app should also support iOS 13.

**Installing the app:**

1. Open Xcode on your app and connect your iPhone or iPad to your Mac using cable.
2. Open the “Magic Media.xcodeproj” file from the project folder on your Mac using Xcode.
3. Once the Xcode file is open, select your iPhone/iPad among the available set of devices among target devices menu in the top panel.

![alt text](https://github.com/ivedants/MagicMedia/blob/main/Image%201.png)

4. In the Project Navigator panel, go to “Signing and Capabilities” tab and select “Team”. If you don’t have an existing team, press “Add an account...” and login using your Apple ID and password.

![alt text](https://github.com/ivedants/MagicMedia/blob/main/Image%202.png)

5. Now, you can press the “Build” button on the top left corner for building the app on your iPhone or iPad. Make sure the device is unlocked while the app is being built.
6. If the app doesn’t open and give a permissions error on your device, then head over to Settings -> Your name (at the very top of the screen) -> Scroll down to a button that says “Developer” and then give permission for the app to run on your iPhone/iPad.
7. This should get the app working on your iPhone/iPad and now, you’re all set to enjoy its features.

**NOTE:** In order to experience audio within the app, make sure your device is not in silent mode. The physical media files that the app supports are in a folder called “Supported Physical Media”. Make sure to either access these files on a tablet kept horizontally surface or print them in preferably two pages (side by side) format. For any queries, suggestions, or collaborations regarding this project, please contact me at ivedantshrivastava@gmail.com.

## AR Application Design

### App triggering AR: 

The app triggers the AR based on markers through image tracking on vertical and horizontal surfaces. The various images/text on the target physical media will be marked and converted into AR objects or interactive videos once the user points the device camera towards them.

<p align="center">
  <img src="https://github.com/ivedants/MagicMedia/blob/main/Image%204.gif" />
</p>

### Combines real and virtual worlds to deliver a wholesome experience:

Besides getting the real experience from the digital or hard copy of the target physical media, the users will also be able to learn more about specific topics and sections through videos or 3D models triggered by AR.

<p align="center">
  <img src="https://github.com/ivedants/MagicMedia/blob/main/Image%205.gif" />
</p>

**Interactive in real-time:**

The AR elements of the app are interactive in real-time. The user can also pause/play the video triggered by the AR at their ease.

<p align="center">
  <img src="https://github.com/ivedants/MagicMedia/blob/main/Image%206.gif" />
</p>

**Image registered in 3D:**

The app recognizes certain images on the target physical media and register them in 3D in order to build an AR element for them and enhance the user’s overall interactive experience.

<p align="center">
  <img src="https://github.com/ivedants/MagicMedia/blob/main/Image%207.gif" />
</p>
