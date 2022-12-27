//
//  SecondScreenViewController.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import UIKit
import CoreData

class SecondScreenViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    var dataInfo: [Payments] = []
    
    private let secondScreenView = SecondScreenView()
    private let model = SecondScreenModel()
    private let firstScreenViewController = FirstScreenViewController()
    private let firstScreenView = FirstScreenView()
    
    override func loadView() {
        super.loadView()
        view = secondScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondScreenView.didLoadUI(controller: self)
        secondScreenView.textField.delegate = self
    }
}

extension SecondScreenViewController {
    func getCellCount() -> Int {
        model.category.count
    }
    
    func getPickerData() -> [String] {
        model.category
    }
    
    func selectedCategory() -> String? {
        model.selectedCategory
    }
    
    func addNewTransaction() {
        saveMoney()
    }
    
    func saveMoney() {
        if secondScreenView.textField.text == "" {
            dismiss(animated: true)
        } else {
            do {
                let data = Payments(context: context)
                data.transactions = Decimal(string: secondScreenView.textField.text ?? "0") as? NSDecimalNumber
                data.date = NSDate() as Date
                data.category = model.selectedCategory
                try context.save()
                print("saved")
                print(data)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            NotificationCenter.default.post(name: Notification.Name("updateView"), object: nil)
            
            firstScreenViewController.viewWillAppear(true)
            dismiss(animated: true)
        }
    }
    
}

extension SecondScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberFormatter().number(from: (textField.text ?? "") + string) != nil
    }
}

extension SecondScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        getCellCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        getPickerData()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? {
            let label: UILabel = UILabel()
            label.font = UIFont.systemFont(ofSize: 30)
            label.textAlignment = .center
            return label
        }()
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = model.category[row]
        model.selectedCategory = selected
    }
}

