//
//  EmployeeDescriptiveViewController.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 19/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import UIKit

class EmployeeDescriptiveViewController: UIViewController {
    
    // Constants
    let genders: [String] = ["Male", "Female"]
    
    // Vars
    var employee: Employee?
    var accessToken: String?
    
    //Views
    
    var employeeImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 80
        imageView.backgroundColor = .black
        
        return imageView
    }()

    var saveButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var firstNameInput: FloatingLabelTextField = {
        let floatingLabelTextField = FloatingLabelTextField()
        
        floatingLabelTextField._placeholder = "First Name"
        floatingLabelTextField.font = .systemFont(ofSize: 32)
        floatingLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return floatingLabelTextField
    }()
    
    var lastNameInput: FloatingLabelTextField = {
        let floatingLabelTextField = FloatingLabelTextField()
        
        floatingLabelTextField._placeholder = "This is a floating label, try clearing the field"
        floatingLabelTextField.font = .systemFont(ofSize: 32)
        floatingLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return floatingLabelTextField
    }()
    
    var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        
        
        configureForm()
    }
    
    func configureForm() {
        configureEmployeeImage()
        
        configureFirstNameInput()
        configureLastNameInput()
        configureSegmentedControl()
        
        configureButton()
    }
    
    fileprivate func configureSegmentedControl() {
        
        // Setting the .selected color
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .selected)

        // Adding the options for the segmented control
        segmentedControl.insertSegment(withTitle: "Male", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Female", at: 1, animated: false)
        
        view.addSubview(segmentedControl)
        
        // Constraining the segmented control
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: lastNameInput.bottomAnchor, constant: 56),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        if employee?.gender == "Male" {
            segmentedControl.selectedSegmentIndex = 0
        } else if employee?.gender == "Female" {
            segmentedControl.selectedSegmentIndex = 1
        }
    }

    
    func configureFirstNameInput() {

        // Checks for firstName, and sets it to the input
        if let firstName = employee?.firstName {
            firstNameInput.text = firstName
            firstNameInput.configureFloatingLAbel()
        }
        
        view.addSubview(firstNameInput)
        
        // Constraining the input
        NSLayoutConstraint.activate([
            firstNameInput.topAnchor.constraint(equalTo: employeeImage.bottomAnchor, constant: 80),
            firstNameInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            firstNameInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32)
        ])
    }
    
    func configureLastNameInput() {
        
        // Checks for lastName, and sets it to the input
        if let lastName = employee?.lastName {
            lastNameInput.text = lastName
            lastNameInput.configureFloatingLAbel()
        }
        
        view.addSubview(lastNameInput)
        
        // Constraining the input
        NSLayoutConstraint.activate([
            lastNameInput.topAnchor.constraint(equalTo: employeeImage.bottomAnchor, constant: 200),
            lastNameInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            lastNameInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32)
        ])
    }

    
    fileprivate func configureFloatingLabelTextField() {
        let floatingLabelTF = FloatingLabelTextField()
        floatingLabelTF._placeholder = "First Name"
        floatingLabelTF.font = UIFont.systemFont(ofSize: 32)

        view.addSubview(floatingLabelTF)
        floatingLabelTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            floatingLabelTF.topAnchor.constraint(equalTo: employeeImage.bottomAnchor, constant: 20),
            floatingLabelTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            floatingLabelTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
        ])
    }
    
    fileprivate func configureEmployeeImage() {
        
        view.addSubview(employeeImage)
        
        NSLayoutConstraint.activate([
            employeeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            employeeImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            employeeImage.widthAnchor.constraint(equalToConstant: 160),
            employeeImage.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    fileprivate func configureButton() {
        saveButton.addTarget(self, action: #selector(saveEmployee), for: .touchUpInside)
        
        view.addSubview(saveButton)
        
        //Constraining the button
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc fileprivate func saveEmployee(sender: UIButton) {
        
        employee?.firstName = firstNameInput.text!
        employee?.lastName = lastNameInput.text!
        employee?.gender = genders[segmentedControl.selectedSegmentIndex]
        
        let rest = RestService()
        let employeeRepo = EmployeeRepository(dataService: rest)
        
        employeeRepo.updateEmployee(employee: employee!, accessToken: accessToken!, onSuccess: {
            self.dismiss(animated: true, completion: nil)
        }) { (data) in
            // Creates alert on main thread with error message
            DispatchQueue.main.async {

                let jsonError = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String: Any]
                if let error = jsonError["error"] as? [String: Any] {
                    if let message = error["message"] {
                        let alertController = UIAlertController(title: "Error", message: "CLIENT ERROR: \(message) \nPlease check everything is filled correctly and try again.", preferredStyle: .alert)

                        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                        }

                        alertController.addAction(action)

                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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

extension EmployeeDescriptiveViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
}
