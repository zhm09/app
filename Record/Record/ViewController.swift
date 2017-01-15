

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var dataList:[RecordListModel] = []

    @IBOutlet weak var createRecord: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource  = self;
        
        createRecord.addTarget(self, action: #selector(createRecordClick), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.tableView.reloadData()
    }

    @IBAction func editClick(_ sender: Any) {
        var view = (sender as AnyObject).superview
        var x = view??.superview
        var cell:UITableViewCell = x as! UITableViewCell
        var indexPath = tableView.indexPath(for: cell)
        
        var model:RecordListModel = self.dataList[(indexPath?.row)!] as RecordListModel
        
        CGSDataManager.shareInstance.updateRecordData(object: model)
        fetchData()
        tableView.reloadData()
    }
    @IBAction func deleteClick(_ sender: Any) {
        var view = (sender as AnyObject).superview
        var x = view??.superview
        var cell:UITableViewCell = x as! UITableViewCell
        var indexPath = tableView.indexPath(for: cell)
        
        var model:RecordListModel = self.dataList[(indexPath?.row)!] as RecordListModel
        
        CGSDataManager.shareInstance.deleteRecordData(object: model)
      
        fetchData()
        tableView.reloadData()
    }
    @IBAction func checkFinishedList(_ sender: Any) {
          let vc : TimeLineTableViewController = TimeLineTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
         //self.present(vc, animated:true)
    }
    func fetchData() -> Void{
        
        self.dataList = CGSDataManager.shareInstance.fetchUnfinishedRecordData()!
    }


    func createRecordClick() -> Void {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var array:Array<Any>
        
        array = self.dataList
  
        return  array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "recordcell"
        let cell:RecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecordTableViewCell
        
        var model:RecordListModel
       
        model = self.dataList[indexPath.row]
    
       
        let formatter = DateFormatter()
        let timeZone = TimeZone.init(identifier: "UTC")
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "MM-dd HH:mm"
        let date = formatter.string(from: model.time as! Date)
        
        cell.titleLabel.text = model.content
        cell.timeLabel.text = date.components(separatedBy: " ").first!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }



}

