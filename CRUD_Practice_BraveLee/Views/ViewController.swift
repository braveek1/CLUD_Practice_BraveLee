//
//  ViewController.swift
//  CLUD_Practice_BraveLee
//
//  Created by YONGKI LEE on 2020/03/02.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

struct Member: Codable {
    var name: String
    var age: Int
}

class ViewController: UIViewController {
    
    var members: [Member] = []

    // UIButton
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var insertButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // UITextField
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    // UITableView
    @IBOutlet weak var resultTableView: UITableView!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        setupTableView()
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.members = UserDefaults.standard.structArrayData(Member.self, forKey: "members")
    }
    
    private func setupTableView() {
        
        let nib = UINib(nibName: CRUDResultTableViewCell.nibName, bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: CRUDResultTableViewCell.nibName)
        
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        self.resultTableView.reloadData()
    }
    
    @IBAction func insertButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        
        // alert
        alertTextFieldCheck()
        
        // guard
        guard let name = nameTextField.text else { return }
        guard let age = Int(ageTextField.text!) else { return }
        
        let member = Member.init(name: name, age: age)
        
        self.members.append(member)
        
        // save UserDefaults
        UserDefaults.standard.setStructArray(self.members, forKey: "members")
        UserDefaults.standard.synchronize()
        
        // alert
        let alertMessage = "name: \(name), age: \(age)가 추가되었습니다."
        let alertController = UIAlertController(title: "Insert Success", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
        self.resultTableView.reloadData()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        
        // alert
        alertTextFieldCheck()
        
        // guard
        guard let name = nameTextField.text else { return }
        guard let age = Int(ageTextField.text!) else { return }
        
        if resultTableView.indexPathForSelectedRow == nil {
            // alert
            let alertMessage = ""
            let alertController = UIAlertController(title: "Insert Success", message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        guard let indexPathForSelectedRow = resultTableView.indexPathForSelectedRow else { return }
        
        let selectedMember = self.members[indexPathForSelectedRow.row]
        
        // alert
        let alertMessage = "name: \(selectedMember.name), age: \(selectedMember.age)를 수정하시겠습니까?"
        let alertController = UIAlertController(title: "update Success", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: UIAlertAction.Style.cancel, handler: { action in
            self.members[indexPathForSelectedRow.row].name = name
            self.members[indexPathForSelectedRow.row].age = age
            UserDefaults.standard.setStructArray(self.members, forKey: "members")
            UserDefaults.standard.synchronize()
            self.resultTableView.reloadData()
        })
        let action2 = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        if self.members.endIndex > 0 {
            
            let indexPathForSelectedRow = resultTableView.indexPathForSelectedRow.or(defaultValue: IndexPath(row: self.members.endIndex-1, section: 0)) as! IndexPath
            
            let selectedMember = self.members[indexPathForSelectedRow.row]
            
            // alert
            let alertMessage = "name: \(selectedMember.name), age: \(selectedMember.age)를 삭제하시겠습니까?"
            let alertController = UIAlertController(title: "delete Success", message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "YES", style: UIAlertAction.Style.cancel, handler: { action in
                self.members.remove(at: indexPathForSelectedRow.row)
                UserDefaults.standard.setStructArray(self.members, forKey: "members")
                UserDefaults.standard.synchronize()
                self.resultTableView.reloadData()
            })
            let action2 = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(action)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    private func hideKeyboard() {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }
    
    private func alertTextFieldCheck() {
        if nameTextField.text == "" {
            let alertMessage = "please nameTextfield"
            let alertController = UIAlertController(title: "error", message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "YES", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if ageTextField.text == "" {
            let alertMessage = "please ageTextfield"
            let alertController = UIAlertController(title: "error", message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "YES", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CRUDResultTableViewCell.nibName, for: indexPath) as? CRUDResultTableViewCell else { return UITableViewCell() }
        
        
        let member = self.members[indexPath.row]
        cell.nameText.text = member.name
        cell.ageText.text = String(member.age)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
        }*/
        print("select: ", self.members[indexPath.row])
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will select: ", self.members[indexPath.row])
        
        if indexPath == tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        } else {
            return indexPath
        }
    }
}

extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

extension Optional {
    func or(defaultValue: Any) -> Any {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value
        }
    }
}
