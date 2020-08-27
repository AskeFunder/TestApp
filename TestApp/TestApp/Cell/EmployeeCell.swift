//
//  EmployeeCell.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 19/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    var employeeImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 40
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "John Doe"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(20)
        
        return label
    }()
    
    var departmentLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Imaginary Department"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(14)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(employeeImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(departmentLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        //Setting the constraints for the name label
        NSLayoutConstraint.activate([
            employeeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            employeeImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            employeeImage.heightAnchor.constraint(equalToConstant: 80),
            employeeImage.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        //Setting the constraints for the departments label
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -6),
            nameLabel.leftAnchor.constraint(equalTo: employeeImage.rightAnchor, constant: 24),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            departmentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 18),
            departmentLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 12),
        ])
    }
}
