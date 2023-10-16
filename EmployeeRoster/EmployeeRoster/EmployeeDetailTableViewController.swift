
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableDelagate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    var isEditingDate = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var employeeType: EmployeeType?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableTableViewController? {
        let vc = EmployeeTypeTableTableViewController(coder: coder)
        vc?.delegate = self
        return vc
    }
    
    func employeeTypeTableViewController(_: EmployeeTypeTableTableViewController, didSelect: EmployeeType) {
        employeeType = didSelect
        employeeTypeLabel.textColor = .label
        employeeTypeLabel.text = employeeType?.description
        updateSaveButtonState()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    @IBAction func dobChanged(_ sender: Any) {
        dobLabel.text = datePicker.date.formatted(date: .abbreviated, time: .omitted)
        date = datePicker.date
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 1, section: 0) {
            isEditingDate.toggle()
            dobLabel.textColor = .label
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 2, section: 0) && isEditingDate == false {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    private func updateSaveButtonState() {
        var shouldEnableSaveButton = false
        
        if !nameTextField.text!.isEmpty && date != nil && employeeType != nil {
            shouldEnableSaveButton = true
        }
        
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        let employee = Employee(name: name, dateOfBirth: datePicker.date, employeeType: employeeType ?? .exempt)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }

}
