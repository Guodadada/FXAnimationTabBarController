//
//  FXAnimatedTabBarItem.swift
//  AnimationTabBar
//
//  Created by V on 16/2/23.
//  Copyright © 2016年 guofengxian. All rights reserved.
//

import UIKit

public let ScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width

class AnimationTabBarController: UITabBarController {
    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = []
    var iconsImageName:[String] = []
    var iconsSelectedImageName:[String] = []
    var shopCarIcon: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func createViewContainers() -> [String: UIView] {
        var containersDict = [String: UIView]()
        guard let customItems = tabBar.items as? [FXAnimatedTabBarItem] else
        {
            return containersDict
        }
        
        for index in 0..<customItems.count {
            let viewContainer = createViewContainer(index)
            containersDict["container\(index)"] = viewContainer
        }
        return containersDict
    }
    
    func createViewContainer(index: Int) -> UIView {
        let viewWidth: CGFloat = ScreenWidth / CGFloat(tabBar.items!.count)
        let viewHeight: CGFloat = tabBar.bounds.size.height
        let viewContainer = UIView(frame: CGRectMake(viewWidth * CGFloat(index), 0, viewWidth, viewHeight))
        viewContainer.backgroundColor = UIColor.clearColor()
        viewContainer.userInteractionEnabled = true
        tabBar.addSubview(viewContainer)
        viewContainer.tag = index
        let tap = UITapGestureRecognizer(target: self, action: "tabBarClick:")
        viewContainer.addGestureRecognizer(tap)
        return viewContainer
    }
    
    
    func createCustomIcons(containers : [String: UIView]) {
        if let items = tabBar.items {
            for (index, item) in items.enumerate() {
                assert(item.image != nil, "add image icon in UITabBarItem")
                guard let container = containers["container\(index)"] else
                {
                    print("No container given")
                    continue
                }
                container.tag = index
                
                let imageW:CGFloat = 21
                let imageX:CGFloat = (ScreenWidth / CGFloat(items.count) - imageW) * 0.5
                let imageY:CGFloat = 8
                let imageH:CGFloat = 21
                let icon = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
                icon.image = item.image
                icon.tintColor = UIColor.clearColor()
                
                // text
                let textLabel = UILabel()
                textLabel.frame = CGRectMake(0, 32, ScreenWidth / CGFloat(items.count), 49 - 32)
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.font = UIFont.systemFontOfSize(10)
                textLabel.textAlignment = NSTextAlignment.Center
                textLabel.textColor = UIColor.grayColor()
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(icon)
                container.addSubview(textLabel)
                
                if let tabBarItem = tabBar.items {
                    let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBarItem.count)
                    textLabel.bounds.size.width = textLabelWidth
                }
                
                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)
                
                item.image = nil
                item.title = ""
                
                if index == 0 {
                    selectedIndex = 0
                    selectItem(0)
                }
            }
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        setSelectIndex(from: selectedIndex, to: item.tag)
    }
    
    func selectItem(Index: Int) {
        let items = tabBar.items as! [FXAnimatedTabBarItem]
        let selectIcon = iconsView[Index].icon
        selectIcon.image = UIImage(named: iconsSelectedImageName[Index])!
        items[Index].selectedState(selectIcon, textLabel: iconsView[Index].textLabel)
    }
    
    func setSelectIndex(from from: Int,to: Int) {
        selectedIndex = to
        let items = tabBar.items as! [FXAnimatedTabBarItem]
        
        let fromIV = iconsView[from].icon
        fromIV.image = UIImage(named: iconsImageName[from])
        items[from].deselectAnimation(fromIV, textLabel: iconsView[from].textLabel)
        
        let toIV = iconsView[to].icon
        toIV.image = UIImage(named: iconsSelectedImageName[to])
        items[to].playAnimation(toIV, textLabel: iconsView[to].textLabel)
    }
    
    func tabBarControllerAddChildViewController(childView: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
        let vcItem = FXAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        vcItem.animation = FXBounceAnimation()
        childView.tabBarItem = vcItem
        
        self.iconsImageName.append(imageName)
        self.iconsSelectedImageName.append(selectedImageName)
        
        addChildViewController(childView)
    }
    
    override func viewDidAppear(animated: Bool) {
        let containers = createViewContainers()
        createCustomIcons(containers)
    }
    
}


class FXBounceAnimation : FXItemAnimation {
    
    override func playAnimation(icon : UIImageView, textLabel : UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }
    
    override func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysOriginal)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
        }
    }
    
    override func selectedState(icon : UIImageView, textLabel : UILabel) {
        textLabel.textColor = textSelectedColor
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysOriginal)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }
    
    func playBounceAnimation(icon : UIImageView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic
        icon.layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
        if let iconImage = icon.image {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysOriginal)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }
}


class FXAnimatedTabBarItem: UITabBarItem {
    var animation: FXItemAnimation?
    var textColor = UIColor.grayColor()
    func playAnimation(icon: UIImageView, textLabel: UILabel){
        guard let animation = animation else {
            print("add animation in UITabBarItem")
            return
        }
        animation.playAnimation(icon, textLabel: textLabel)
    }
    
    func deselectAnimation(icon: UIImageView, textLabel: UILabel) {
        animation?.deselectAnimation(icon, textLabel: textLabel, defaultTextColor: textColor)
    }
    
    func selectedState(icon: UIImageView, textLabel: UILabel) {
        animation?.selectedState(icon, textLabel: textLabel)
    }
}

protocol FXItemAnimationProtocol {
    func playAnimation(icon : UIImageView, textLabel : UILabel)
    func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor)
    func selectedState(icon : UIImageView, textLabel : UILabel)
}

class FXItemAnimation: NSObject, FXItemAnimationProtocol {
    var duration : CGFloat = 0.6
    var textSelectedColor: UIColor = UIColor.grayColor()
    var iconSelectedColor: UIColor?
    
    func playAnimation(icon : UIImageView, textLabel : UILabel) {
    }
    
    func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        
    }
    
    func selectedState(icon: UIImageView, textLabel : UILabel) {
    }
    
}
