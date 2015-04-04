import UIKit

class ViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    let SYNCCellIdentifier = "CellID"
    let SYNCReloadTableNotification = "SYNCReloadTableNotification"

    var dataStack: DATAStack!
    var arrayWithData: NSArray!

    // MARK: Initializers

    required init(dataStack: DATAStack) {
        super.init(nibName: nil, bundle: nil);
        self.dataStack = dataStack
    }

    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil);
    }

    // MARK: TableView methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayWithData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(SYNCCellIdentifier) as UITableViewCell
        cell.textLabel!.text = self.arrayWithData[indexPath.row] as NSString
        return cell
    }

    // MARK: Notification

    func finishedFetchingPosts() {

        self.tableView.reloadData()
    }

    // MARK: Networking methods

    func fetchNewData() {
        var networking = Networking(dataStack: self.dataStack)
        networking.fetchNewContent()
    }

    // MARK: Model methods

    func fetchCurrentObjects() {
        var request = NSFetchRequest(entityName: "Data")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        self.arrayWithData = self.dataStack.mainContext.executeFetchRequest(request, error: nil)

        self.tableView.reloadData()
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.arrayWithData = NSArray()

        self.title = "AppNet"

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "finishedFetchingPosts", name: SYNCReloadTableNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.fetchNewData()
    }
}

