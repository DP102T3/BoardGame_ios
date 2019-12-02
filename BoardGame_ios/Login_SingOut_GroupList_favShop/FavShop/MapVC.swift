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
    var favshop: ShopData!
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title? = favshop.shopName
            if favshop.latitude == nil || favshop.latitude! < -180.0 || favshop.longitude == nil || favshop.longitude! < -180.0 {
                showSimpleAlert(message: "The data is not found on the map!", viewController: self)
            } else {
                setupMap();
            }
        }
        
        func setMapRegion() {
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            var region = MKCoordinateRegion()
            region.span = span
            mapView.setRegion(region, animated: true)
            mapView.regionThatFits(region)
        }
        
        func setupMap() {
            mapView.delegate = self
            setMapRegion()
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: favshop.latitude!, longitude: favshop.longitude!)
            annotation.coordinate = coordinate
            annotation.title = "\(favshop.shopName))"
            annotation.subtitle = favshop.address
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
        
    }

