import UIKit

// Need a developer account

class ViewController: UITableViewController {
    
    var tasks = [Task]()
/*    var tasks = [
        Task(title: "Vaske klær 🤯"),
        Task(title: "Drikke øl 🍺"),
        Task(title: "Kjøpe flybiletter"),
        Task(title: "Send email")
    ]
  */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add date as a title
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        title = dateFormatter.string(from: Date())
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        loadTasks()

    }
    
    @objc func addItem(){
        let alert = UIAlertController(title: "What do you need to get done", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        // This is the code wich will make it into a new task
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let text = alert.textFields?.last?.text {
                let indexPath = IndexPath(row: self.tasks.count, section: 0)
                let task = Task(title: text)
                self.tasks.append(task)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.saveTasks() // This is added in step 7. You need to use self if you're inside a handle
            }
        })
        
        alert.addAction(saveAction)
        
        // Nothing really happens when you cancel. It goes back to default mode.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        alert.preferredAction = saveAction
        present(alert, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection:Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.textLabel?.text = "Hello there" //nullability
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let complete = UITableViewRowAction(style: .normal, title: "Complete") { (_, indexPath) in
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveTasks() // This was added in step 7
        }
        
        complete.backgroundColor = view.tintColor // use the tint color of the whole app
        
        return[complete]
        
    }
    
    // File manager is a function to fined a document directoru inside my app, and create a new folder called tasks
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // Make a folder called tasks
    static let archiveURL = documentsDirectory.appendingPathComponent("tasks")
    
    // Archive the data in the folder
    func saveTasks() {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
        try! data.write(to: ViewController.archiveURL)
    }
    
    // Using "guard" let us have if else sentences without acutally using indents
    // The loadtask function 
    func loadTasks(){
        guard let data = FileManager().contents(atPath: ViewController.archiveURL.path) else { return }
        tasks = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Task] ?? [Task]()
    }
    
}

