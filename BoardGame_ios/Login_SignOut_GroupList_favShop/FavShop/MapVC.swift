//
//  MapVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/11/30.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController , MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: Double?
    var longitude: Double?
    var favshop: Shop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(favshop.shopName)
        self.title = favshop.shopName
        geocoder()
        setupMap()
    }
    
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        var region = MKCoordinateRegion()
        region.span = span
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
    
    func setupMap() {
        mapView.delegate = self
        setMapRegion()
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        annotation.coordinate = coordinate
        annotation.title = "\(favshop.shopName))"
        annotation.subtitle = favshop.shopAddress
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        /* MKPinAnnotationView物件可以設定圖針顏色以及圖針掉落動畫 */
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.animatesDrop = true
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func setMapCenter(center: CLLocationCoordinate2D) {
        mapView.setCenter(center, animated: true)
    }
    
    func setMapAnnotation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = favshop.shopName
        annotation.subtitle = favshop.shopAddress
        mapView.addAnnotation(annotation)
    }
    
    func geocoder(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(favshop!.shopAddress!) { (placemarks, error) in
            if placemarks != nil && placemarks!.count > 0 {
                if let placemark = placemarks!.first {
                    let location = placemark.location!
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    self.setMapCenter(center: location.coordinate)
                    self.setMapAnnotation(location)
                }
            }
        }
        
    }
}
