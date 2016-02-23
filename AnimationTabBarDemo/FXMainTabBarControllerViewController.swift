//
//  FXMainTabBarControllerViewController.swift
//  AnimationTabBar
//
//  Created by V on 16/2/23.
//  Copyright © 2016年 guofengxian. All rights reserved.
//

import UIKit

class FXMainTabBarControllerViewController: AnimationTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildMainTabBarChildViewController()
        
    }
    
    
    private func buildMainTabBarChildViewController() {
        
        // 添加子控制器(包裹navigationController)
        let nav = UINavigationController(rootViewController: ViewControllerOne())
        nav.navigationBar.topItem?.title = "ONE"
        tabBarControllerAddChildViewController(nav, title: "ONE", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected", tag: 0)
        
        let nav1 = UINavigationController(rootViewController: ViewControllerTwo())
        nav1.navigationBar.topItem?.title = "TWO"
        tabBarControllerAddChildViewController(nav1, title: "TWO", imageName: "tabbar_message_center", selectedImageName: "tabbar_message_center_selected", tag: 1)
        
        let nav2 = UINavigationController(rootViewController: ViewControllerThree())
        nav2.navigationBar.topItem?.title = "THREE"
        tabBarControllerAddChildViewController(nav2, title: "THREE", imageName: "tabbar_discover", selectedImageName: "tabbar_discover_selected", tag: 2)
        
        let nav3 = UINavigationController(rootViewController: ViewControllerFour())
        nav3.navigationBar.topItem?.title = "FOUR"
        tabBarControllerAddChildViewController(nav3, title: "FOUR", imageName: "tabbar_profile", selectedImageName: "tabbar_profile_selected", tag: 3)
    }
}
