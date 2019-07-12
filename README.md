# AR basics

This app is a walkthrough of some basic principles of AR. It is based on ARKit 2 but the same principles can be applied to other AR technologies like ARCore.

## Prerequesites

For building and running the app you will need:

* Xcode 10.2
* iOS 12
* A physical device with support of ARKit, [see details here](https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/DeviceCompatibilityMatrix/DeviceCompatibilityMatrix.html)

## Contents of the app

The app will launch an AR session and will show several buttons on the left side of the screen. The different demos contained in the app can be selected using those buttons.

Some of the demos are interactive and the user can manipulate a virtual object using additional buttons. Those additional buttons will be at the bottom of the screen, when applicable.

These are the demos:

1. Feature points, plane detection and world coordinate space
2. Image detection and tracking
3. Coordinate spaces
4. Transformation matrices
5. Direct interaction of the user with virtual objects

### Feature points, plane detection and world coordinate space

In this demo, the app will show the feature points detected by ARKit. Also, it will add the world coordinate space, the reference for the rest of coordinate spaces. Finally, it will detect horizontal planes, adding a placeholder in gray color.

### Image detection and tracking

The app will activate detection and tracking for an image and, once it is detected, it will overlay a video on top of the image. For visualizing this demo you will need to print the image in the specific dimensions you will find in Assets folder.

### Coordinate spaces

In this case, the app will add a virtual object, a cup of coffee, on a detected horizontal plane. For the cup, the app will show the coordinate spaces of the whole object, and also of the coffee sleeve, that is a child of the whole virtual object.

Then, the user will have several additional buttons for:

* Selecting if an action will be applied to the whole coffee cup, or to the coffee sleeve, or both
* Execute an action of rotation or translation

The user can observe the changes in the coordinate spaces and how a transformation on the parent object impacts the child object.

### Transformation matrices

Again with the cup of coffee, the user can apply transformations for traslation, rotation and scaling. That allows checking out the different results depending on the order in which the transformations are applied.

### Direct interaction of the user with virtual objects

Finally, and one more time with the cup of coffee, the user can interact with the cup with a long tap, that will enable the movement of the cup following the finger of the user, constrained to the horizontal plane in which the cup was added.

## Resources

The model of the cup of coffee is [this](https://free3d.com/3d-models/cup). Thanks to [Abringo](https://free3d.com/user/abringo) for sharing this excellent piece of work.

## References

* http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/
* https://developer.apple.com/documentation/arkit
* https://developer.apple.com/design/human-interface-guidelines/ios/system-capabilities/augmented-reality/
* https://developer.apple.com/documentation/arkit
* https://designguidelines.withgoogle.com/ar-design/
* https://developers.google.com/ar/
