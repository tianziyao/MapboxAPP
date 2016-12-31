//
//  Location.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/30.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationDelegate: class {
    func openApplicationSettings()
    func openSystemLocationServerSettings()
    func setCoordinateToMapView(coordinate: CLLocationCoordinate2D)
}

class Location: CLLocationManager {
    
    static let manager = Location()
    
    weak var locationDelegete: LocationDelegate?
    
    var serverIsOpen: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var currentCoordinate: CLLocationCoordinate2D?
    
    /// 检查定位服务的状态
    func checkLocationServer() {
        
        //保证位置服务是开启的，否则开启弹窗打开系统设置
        if serverIsOpen == false {
            locationDelegete?.openApplicationSettings()
        }
        //保证APP的位置服务是开启的，否则开启APP设置
        if authorizationStatus == .denied {
            locationDelegete?.openApplicationSettings()
        }
        //保证授权状态是可用的，否则请求授权
        if authorizationStatus != .authorizedWhenInUse {
            requestAuthorization()
        }
    }
    
    // 将定位位置设定为地图中心
    func setCurrentPositionToMapView() {
        checkLocationServer()
        requestCurrentPosition()
    }
    
    /// 请求授权
    func requestAuthorization() {
        Location.manager.requestWhenInUseAuthorization()
        Location.manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 请求现在的位置
    func requestCurrentPosition() {
        Location.manager.delegate = self
        Location.manager.startUpdatingLocation()
    }
    
    // 计算当前位置和目标位置的距离
    func calculateDistance(target: CLLocationCoordinate2D) -> CLLocationDistance? {
        
        guard Location.manager.currentCoordinate != nil else {
            return nil
        }
        
        return calculateDistance(current: Location.manager.currentCoordinate!, target: target)
    }
    
    // 计算两点之间的距离
    func calculateDistance(current: CLLocationCoordinate2D, target: CLLocationCoordinate2D) -> CLLocationDistance {
        return CLLocation(latitude: current.latitude, longitude: current.longitude).distance(from: CLLocation(latitude: target.latitude, longitude: target.longitude))
    }
}

extension Location: CLLocationManagerDelegate {
    
    // 授权发生变化时
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServer()
    }
    
    // 开始更新位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        currentCoordinate = locations.last?.coordinate
        locationDelegete?.setCoordinateToMapView(coordinate: currentCoordinate!)
    }
    
    // 获取位置出错
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("出错了")
    }
}
