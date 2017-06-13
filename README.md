## UIDebuggingInformationOverlay

前些天，[Ryan Peterson](http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_303) 在看 UIKit 的私有头文件时发现了一个之前没看过的类： `UIDebuggingInformationOverlay`，并把这个发现分享了出来，下面来看看这个类具体的作用。

从类名可以大致知道它是用来 debug 用的。是的，`UIDebuggingInformationOverlay` 是 `UIWindow` 的一个子类，主要是用来给开发者和设计师进行UI调试用的（估计是Apple内部人员使用的）。

它大概是长这样的：

![长这样](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/1.png)

怎么用呢？首先我们得让它显示出来，通过类方法 `prepareDebuggingOverlay` 加载下这个视图，然后又两种方式可以让它显示：

1.调用 `overlay` 方法，拿到实例，再调用实例方法 `toggleVisibility` 即可显示。因为是私有API所以需要用运行时的方式来执行，代码如下：
``` ObjectiveC
// Objective-C
Class overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
[overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
Class overlay = [overlayClass performSelector:NSSelectorFromString(@"overlay")];
[overlay performSelector:NSSelectorFromString(@"toggleVisibility")];
```

``` swift
// swift
let overlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
_ = overlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
let overlay = overlayClass?.perform(NSSelectorFromString("overlay")).takeUnretainedValue() as? UIWindow
_ = overlay?.perform(NSSelectorFromString("toggleVisibility"))
```

2.执行了`prepareDebuggingOverlay`方法之后，只需要通过 **两个手指同时点击顶部状态栏** 即可唤醒这个浮层。

![唤醒](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/唤醒.gif)

显示出来后，再看看具体能做什么。

##### View Hierarchy
显示视图的层级关系，点击又上角的 `Inspect` 可以进行App的视图的选择，并查看视图的详细信息。如果你对 App 有多个 window，可以通过 `Change Current Window` 进行切换查看不同 window 的视图层级关系及各个视图的详细信息。同样的，你也可以查看系统的 window。比如下面查看系统键盘这个 window：

![View Hierarchy](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/View Hierarchy.gif)

##### VC Hierarchy
和 *View Hierarchy* 类似，你可以查看每个 VC 的层级，并且可以查看每个 VC 上视图的详细信息，同时，还提供了所查看的 VC 是否 presenting 了 modal 或者是被 presented。

![VC Hierarchy](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/2.png)

##### Ivar Explorer
Ivar Explorer 可以让开发者查看当前 `UIApplication` 实例的变量。如下，如果变量是个对象，还可以查看对象内部的变量，如：delegate， statusBar 等（后面即将介绍的两个才是重头戏）。

![Ivar Explorer](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/3.png)

##### Measure
从名称上可以知道，这是测量用的。是的，有了它，你就可以直接测量当前视图了。操作起来也很简单：先选择是要测量垂直的还是测量水平的，然后手指在屏幕上移动即可测量。如下：

![Measure](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/4.png)

另外，我们发现，有个开关写着`View Mode`，打开之后，就可以测量每个组件的宽高了，如下：

![View Mode for Measure](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/4_1.png)

##### Spec Compare
这个功能更牛，更实用。设计师给你一张图，你按着图布局完后，想看看是否和UI图一致，之前我都是截个图，然后自己量。有了它，方便了多少自己体会哈。我们可以将UI图添加进来，然后手指向上下滑动来调节图片的透明度（从下到上图片透明度0~1），就可以看出哪些组件布局有问题了。
**提示：** 1. 添加图片后，调试框会隐藏，双击屏幕即可重新显示； 2. 由于添加图片需要访问图片库，所以需要在项目的plist文件上添加 `Privacy - Photo Library Usage Description` 这一项，描述内容自定。
效果如下：

![UI Compare](https://github.com/linshaolie/DebuggingOverlayDemo/blob/master/resources/UI对比.gif)

##### 最后
以上，就是 `UIDebuggingInformationOverlay` 的基本使用，能否利用它来做更多调试的事情，就得靠自己去挖掘了。
