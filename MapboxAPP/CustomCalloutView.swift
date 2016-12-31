//
//  CustomCalloutView.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/31.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import Mapbox

class CustomCalloutView: UIView, MGLCalloutView {
    
    var representedObject: MGLAnnotation
    
    internal var leftAccessoryView = UIView() /* unused */
    internal var rightAccessoryView = UIView() /* unused */
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    
    let mainBody: UIButton
    
    required init(representedObject: MGLAnnotation) {
        
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        mainBody.backgroundColor = .darkGray
        mainBody.tintColor = .white
        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        mainBody.layer.cornerRadius = 4.0
        mainBody.setTitle("主标题", for: UIControlState())
        mainBody.sizeToFit()
        addSubview(mainBody)
    }
    
    required init(representedObject: MGLAnnotation, model: CallOutModel) {
        
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        mainBody.backgroundColor = .darkGray
        mainBody.tintColor = .white
        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        mainBody.layer.cornerRadius = 4.0
        mainBody.setTitle(model.title, for: UIControlState())
        mainBody.sizeToFit()
        addSubview(mainBody)
    }
    
    required init(representedObject: MGLAnnotation, models: [AnnotationModel]) {
        
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        let model = models[Int.init(representedObject.subtitle!!)!].callOut
        
        mainBody.backgroundColor = .darkGray
        mainBody.tintColor = .white
        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        mainBody.layer.cornerRadius = 4.0
        mainBody.setTitle(model?.title, for: UIControlState())
        mainBody.sizeToFit()
        addSubview(mainBody)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 弹出吹出框
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        
        let selector = #selector(getter: MGLAnnotation.title)
        // 判断是否实现了title的getter方法
        if !representedObject.responds(to: selector) {
            return
        }
        // 添加吹出框到标记
        view.addSubview(self)
        
        // 如果吹出框可以点击，添加calloutView的代理方法calloutViewTapped
        if isCalloutTappable() {
            mainBody.addTarget(self, action: #selector(CustomCalloutView.calloutTapped), for: .touchUpInside)
        }
        // 如果吹出框不可点击，mainBody不可点击
        else {
            mainBody.isUserInteractionEnabled = false
        }
        
        // 设置吹出框的Frame
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    // 移除吹出框
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                    })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // 判断吹出框能否点击
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    // 吹出框点击事件
    func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // 绘制三角形
    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom
        let fillColor : UIColor = .darkGray
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
