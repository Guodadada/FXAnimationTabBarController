# FXAnimationTabBarController
- 实现点击UITabBarItem抖动效果，可以自定义包裹UINavigationController
- 
![image](/FXAnimationTabBarController/FXAnimationTabBar.gif)


##实现步骤简单方便
###实现步骤
* 导入框架文件FXAnimationTabBarController.swift
* 创建一个继承 AnimationTabBarController 类的 TabBarControllerViewController
* 调用提供的方法添加子控制器：

```c
tabBarControllerAddChildViewController
(       childView: UIViewController, 
title: String, 
imageName: String, 
selectedImageName: String, 
tag: Int) 
```

* 可以自定义包裹UINavigationController，比如

```c
// 添加子控制器(包裹navigationController)
let nav = UINavigationController(rootViewController: ViewControllerOne())
nav.navigationBar.topItem?.title = "ONE"
tabBarControllerAddChildViewController(nav, title: "ONE", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected", tag: 0)
```

* 尽情运行下看看效果吧少年们

* 具体实现参看demo 