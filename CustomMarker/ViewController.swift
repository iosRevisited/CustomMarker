//
//  ViewController.swift
//  CustomMarker
//
//  Created by Sai Sandeep on 11/12/19.
//  Copyright © 2019 Sai Sandeep. All rights reserved.
//

import UIKit
import GoogleMaps

let primaryColor = UIColor(red:0.00, green:0.19, blue:0.56, alpha:1.0)

let secondaryColor = UIColor(red:0.89, green:0.15, blue:0.21, alpha:1.0)

struct SSPlace {
    var name: String?
    var address: String?
    var coordinates: (lat: Double, lng: Double)?
}

let customMarkerWidth: Int = 50
let customMarkerHeight: Int = 56

class ViewController: UIViewController {
    
    var places = [SSPlace]()
    
    var markers = [GMSMarker]()
    
    var mapView: GMSMapView = {
        let v = GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        mapView.padding = UIEdgeInsets(top: 72, left: 25, bottom: 0, right: 25)
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.delegate = self
        places.append(SSPlace(name: "Fremont Troll", address: "N 36th St, Seattle, WA 98103, United States", coordinates: (lat: 47.651105, lng: -122.347347)))
        places.append(SSPlace(name: "Grand Canyon National Park", address: "Arizona, United States", coordinates: (lat: 36.099982, lng: -112.123640)))
        places.append(SSPlace(name: "Statue of Liberty National Monument", address: "New York, NY 10004, United States", coordinates: (lat: 40.689323, lng: -74.044490)))
        places.append(SSPlace(name: "Yellowstone National Park", address: "United States", coordinates: (lat: 44.429311, lng: -110.588112)))
        places.append(SSPlace(name: "Walt Disney World Resort", address: "Orlando, FL, United States", coordinates: (lat: 28.385280, lng: -81.563853)))
        self.addMarkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.focusMapToShowAllMarkers()
    }
    
    func addMarkers() {
        
        markers.removeAll()
        for (index, place) in places.enumerated() {
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: place.name, borderColor: primaryColor, tag: index)
            //            marker.iconView=customMarker
            marker.iconView = customMarker
            marker.position = CLLocationCoordinate2D(latitude: place.coordinates!.lat, longitude: place.coordinates!.lng)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
            marker.map = self.mapView
            marker.zIndex = Int32(index)
            marker.userData = place
            markers.append(marker)
        }
    }
    
    func focusMapToShowAllMarkers() {
        if let firstLocation = markers.first?.position {
            var bounds =  GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
            
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 20)
            self.mapView.animate(with: update)
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let imgName = customMarkerView.imageName
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: secondaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let place = marker.userData as? SSPlace {
            marker.tracksInfoWindowChanges = true
            let infoWindow = CustomMarkerInfoWindow()
            infoWindow.tag = 5555
            let height: CGFloat = 65
            let paddingWith = height + 16 + 32
            infoWindow.frame = CGRect(x: 0, y: 0, width: getEstimatedWidthForMarker(place, padding: paddingWith) + paddingWith, height: height)
            infoWindow.imgView.image = UIImage(named: place.name!)
            infoWindow.txtLabel.text = place.name
            infoWindow.subtitleLabel.text = place.address
            return infoWindow
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let place = marker.userData as? SSPlace {
            print("Info window tapped", place)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        //        self.fetchSpots()
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let imgName = customMarkerView.imageName
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: primaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func getEstimatedWidthForMarker(_ place: SSPlace, padding: CGFloat) -> CGFloat {
        var estimatedWidth: CGFloat = 0
        let infoWindow = CustomMarkerInfoWindow()
        let maxWidth = (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.7 : UIScreen.main.bounds.width * 0.8) - padding
        let titleWidth = (place.name ?? "").width(withConstrainedHeight: infoWindow.txtLabel.frame.height, font: infoWindow.txtLabel.font)
        let subtitleWidth = (place.address ?? "").width(withConstrainedHeight: infoWindow.subtitleLabel.frame.height, font: infoWindow.subtitleLabel.font)
        estimatedWidth = min(maxWidth, max(titleWidth, subtitleWidth))
        return estimatedWidth
    }
    
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
