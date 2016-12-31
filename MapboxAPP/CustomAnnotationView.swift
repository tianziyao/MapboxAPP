//
//  CustomAnnotationView.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/30.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import Mapbox

class CustomAnnotationView: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
    

    class func createNormalAnnotations(withCoordinates models: [AnnotationModel]) -> [MGLPointAnnotation] {
        
        var normalAnnotationViews = [MGLPointAnnotation]()
        for model in models {
            normalAnnotationViews.append(createNormalAnnotation(withCoordinate: model))
        }
        return normalAnnotationViews
    }
    
    class func createNormalAnnotation(withCoordinate model: AnnotationModel) -> MGLPointAnnotation {
        
        let normalAnnotationView = MGLPointAnnotation()
        normalAnnotationView.coordinate = model.coordinate
        normalAnnotationView.title = model.title
        normalAnnotationView.subtitle = model.subTitle
        return normalAnnotationView
    }
    
    class func normalConvertToCustom(mapView: MGLMapView, annotation: MGLAnnotation, size: CGSize) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        //使用Title作为标注的识别符
        let reuseIdentifier = annotation.title!
        //通过识别符找到可重用的标注
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier!)
        //如果没有可重用的识别符，使用标识符初始化自定义标注
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        return annotationView
    }
}
