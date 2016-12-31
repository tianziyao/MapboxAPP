//
//  AnnotationModel.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/31.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import CoreLocation

class AnnotationModel: NSObject {

    var title: String!
    var subTitle: String!
    var coordinate: CLLocationCoordinate2D!
    var callOut: CallOutModel!

    init(withData data: [String : Any]) {
        title = data["title"] as! String!
        subTitle = data["subTitle"] as! String
        coordinate = CLLocationCoordinate2D(latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double)
        callOut = CallOutModel(withData: data["callOut"] as! [String : Any])
    }
    
    class func initAnnotationModels(withDatas datas: [[String : Any]]) -> [AnnotationModel] {
        
        var teme: [AnnotationModel] = []
        
        for data in datas {
            teme.append(AnnotationModel(withData: data))
        }
        return teme
    }
}

class CallOutModel: NSObject {
    
    var title: String!
    
    init(withData data: [String : Any]) {
        title = data["title"] as! String!
    }
}
