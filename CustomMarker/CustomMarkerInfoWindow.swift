//
//  CustomMarkerInfoWindow.swift
//  CustomMarker
//
//  Created by Sai Sandeep on 11/12/19.
//  Copyright © 2019 Sai Sandeep. All rights reserved.
//


import UIKit

class CustomMarkerInfoWindow: UIView {
    
    var txtLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var subtitleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var chevronButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var imgView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = primaryColor
        self.addSubview(imgView)
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, multiplier: 1).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 5
        imgView.layer.masksToBounds = true
        imgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        self.addSubview(chevronButton)
        chevronButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        chevronButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        chevronButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        chevronButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        chevronButton.setImage(UIImage(named: "chevron"), for: .normal)
        chevronButton.tintColor = UIColor.white
        chevronButton.isUserInteractionEnabled = false
        
        self.addSubview(txtLabel)
        txtLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4).isActive = true
        txtLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8).isActive = true
        txtLabel.trailingAnchor.constraint(equalTo: chevronButton.leadingAnchor, constant: -8).isActive = true
        txtLabel.bottomAnchor.constraint(greaterThanOrEqualTo: centerYAnchor, constant: 2).isActive = true
        txtLabel.font = UIFont.boldSystemFont(ofSize: 16)
        txtLabel.numberOfLines = 2
        txtLabel.textColor = UIColor.white
        txtLabel.text = "dfsdfd"
        
        self.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 0).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: txtLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.text = "55656556"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        layer.shadowColor = UIColor.shadowColor.cgColor
        //        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //        layer.shadowOpacity = 1.0
        //        layer.shadowRadius = 2
        layer.masksToBounds = true
        layer.cornerRadius = 5
    }
    
}
