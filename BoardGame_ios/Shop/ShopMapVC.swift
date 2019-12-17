//
//  ShopMapVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/16.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit
import MapKit

class ShopMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var MapView: MKMapView!
    var latitude: Double?
    var longitude: Double?
    var shop: Shop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geocoder()
        setupMap()
        // Do any additional setup after loading the view.
    }
    
    func setMapRegion() {
           let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
           var region = MKCoordinateRegion()
           region.span = span
           MapView.setRegion(region, animated: true)
           MapView.regionThatFits(region)
       }
       
    func setupMap() {
        MapView.delegate = self
        setMapRegion()
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        annotation.coordinate = coordinate
        annotation.title = "\(shop.shopName))"
        annotation.subtitle = shop.shopAddress
        MapView.addAnnotation(annotation)
        MapView.setCenter(coordinate, animated: true)
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
        MapView.setCenter(center, animated: true)
    }
    
    func setMapAnnotation(_ location: CLLocation) {
           let coordinate = location.coordinate
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
           annotation.title = shop.shopName
           annotation.subtitle = shop.shopAddress
           MapView.addAnnotation(annotation)
    }
    
    func geocoder(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(shop.shopAddress ?? "") { (placemarks, error) in
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
