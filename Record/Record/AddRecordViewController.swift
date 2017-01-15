

import UIKit

class AddRecordViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var commitBtn: UIButton!

    @IBOutlet weak var addReordBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model:RecordListModel?
    var imgArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReordBtn.addTarget(self, action: #selector(addRecord), for: UIControlEvents.touchUpInside)
        commitBtn.addTarget(self, action: #selector(commitClick), for: UIControlEvents.touchUpInside)
        imgArray = NSMutableArray.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let formatter = DateFormatter()
        let timeZone = TimeZone.init(identifier: "UTC")
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "MM-dd HH:mm"
        let date = formatter.string(from:Date())
        timeLabel.text = date
       
        
        var button: UIButton = UIButton.init()
        button.setTitle("完成", for: UIControlState.normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
     //   self.navigationController?.navigationBar.setItems(button, animated: true)
        //self.model = RecordListModel()
        // Do any additional setup after loading the view.
    }

    func addRecord() -> Void {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    
    }
    func commitClick() -> Void {
        let dic:NSDictionary = NSDictionary.init(objects: [textField.text ?? "text",Date(),false], forKeys: ["content" as NSCopying,"time" as NSCopying, "isFinished" as NSCopying])
        self.model = RecordListModel.manageContex(keyValues: dic as! [String : AnyObject]) as? RecordListModel
        CGSDataManager.shareInstance.insertRecordData(entity: self.model!)
        self.navigationController?.popViewController(animated: true)
    }
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        print(info)
        
        //显示的图片
        let image:UIImage!
       
        //获取选择的原图
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgArray?.add(image)
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //...
        return (imgArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecordImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for:indexPath as IndexPath) as! RecordImageCollectionViewCell
        cell.imageView.image = imgArray?.object(at: indexPath.row) as! UIImage?
        
        return cell as RecordImageCollectionViewCell
      
    }
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
