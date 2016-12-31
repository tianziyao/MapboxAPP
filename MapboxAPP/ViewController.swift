//
//  ViewController.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/30.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import Mapbox
import SnapKit

class ViewController: UIViewController {
    
    var mapView: MGLMapView!
    var addAnnotationsButton: UIButton!
    
    var annotations: [MGLPointAnnotation]?
    var annotationModels: [AnnotationModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Location.manager.locationDelegete = self
        createWidget()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Location.manager.setCurrentPositionToMapView()
    }
    
    func createWidget() {
        
        mapView = MGLMapView(frame: self.view.frame)
        
        /*
         1.在 https://www.mapbox.com/studio/styles/ 设定地图的样式
         2.使用默认的地图样式，通过 MGLStyle.darkStyleURLWithVersion(9) 调用
         
         darkStyle: mapbox://styles/tianziyao/cixbvkano00ds2pohk13nyn5y
         lightStyle: mapbox://styles/tianziyao/cixbuzw9h00d42ppdgb0llehl */
        
        mapView.styleURL = URL(string: "mapbox://styles/tianziyao/cixbvkano00ds2pohk13nyn5y")
        
        //设置地图的中心点和缩放等级
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        mapView.setCenter(coordinate, zoomLevel: 13, animated: false)
        
        //隐藏logo和内置链接按钮
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        
        //设置代理
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        addAnnotationsButton = UIButton(type: .custom)
        addAnnotationsButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addAnnotationsButton.setTitle("添加标注", for: UIControlState())
        addAnnotationsButton.addTarget(self, action: #selector(addAnnotations(sender:)), for: .touchUpInside)
        addAnnotationsButton.frame = CGRect(x: 0, y: 0, width: 120, height: 35)
        addAnnotationsButton.center = CGPoint(x: view.bounds.size.width / 2, y: 50)
        addAnnotationsButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        addAnnotationsButton.layer.cornerRadius = 10
        view.addSubview(addAnnotationsButton)        
    }
    
    func addAnnotations(sender: UIButton) {
    
        if annotations != nil {
            mapView.removeAnnotations(annotations!)
        }
        
        let datas: [[String : Any]] = [["title":"CustomAnnotation", "subTitle":"0", "latitude":0.0, "longitude":33.0, "callOut":["title":"第1个标记"]],
                                    ["title":"CustomAnnotation", "subTitle":"1", "latitude":0.0, "longitude":66.0, "callOut":["title":"第2标记"]],
                                    ["title":"CustomAnnotation", "subTitle":"2", "latitude":0.0, "longitude":99.0, "callOut":["title":"第3个标记"]]]
        
        
        annotationModels = AnnotationModel.initAnnotationModels(withDatas: datas)
        
        mapView.centerCoordinate = (annotationModels?[1].coordinate)!
        annotations = CustomAnnotationView.createNormalAnnotations(withCoordinates: annotationModels!)
        mapView.addAnnotations(annotations!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: MGLMapViewDelegate {
    
    
    // 自定义Annotation视图
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        return CustomAnnotationView.normalConvertToCustom(mapView: mapView, annotation: annotation, size: CGSize(width: 20, height: 20))
    }
    
    // 是否显示吹出框
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // 自定义CallOut视图
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        
        let selector = #selector(getter: MGLAnnotation.title)
        
        if annotation.responds(to: selector) && annotation.title! == "CustomAnnotation" {
            
            return CustomCalloutView.init(representedObject: annotation, models: annotationModels!)
        }
        
        return nil
    }
    
    // 点击CallOut事件
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        
        print("Tapped the callout for: \(annotation)")
        // 取消annotation的选中状态
        mapView.deselectAnnotation(annotation, animated: true)
        // 计算标记和定位之间的距离
        print(Location.manager.calculateDistance(target: annotation.coordinate))
    }
}

extension ViewController: LocationDelegate {
    
    func openApplicationSettings() {
        
        let alertController = AlertController.createAlert(leftAction: {
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                UIApplication.shared.open(settingsUrl!, completionHandler: nil)
            }
            }, title: "提示", message: "请开启系统定位", leftActionTitle: "设置", rightActionTitle: "取消")
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openSystemLocationServerSettings() {
        
        let alertController = AlertController.createAlert(leftAction: { 
            let settingsUrl = URL(string: "prefs:root=LOCATION_SERVICES")
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                UIApplication.shared.open(settingsUrl!, completionHandler: nil)
            }
            }, title: "提示", message: "请开启APP定位", leftActionTitle: "设置", rightActionTitle: "取消")
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setCoordinateToMapView(coordinate: CLLocationCoordinate2D) {
        mapView.centerCoordinate = coordinate
        //mapView.showsUserLocation = true
    }
}

