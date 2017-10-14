import UIKit
import PureLayout


@objc(IsLandViewController)
class IslandViewController: MittyViewController {
    
    var meetingSegments : UISegmentedControl = UISegmentedControl(items: ["Public", "Private"])
    
    // MARK: - Properties
    var meetingList: [MeetingInfo]
    
    // MARK: - View Elements
    let topImage: UIImageView
    
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init() {
        meetingList = [MeetingInfo]()
        self.topImage = UIImageView.newAutoLayout()
        self.topImage.image = UIImage(named: "penginland")
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isScrollEnabled = true
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.autoCloseKeyboard()
        
        LoadingProxy.set(self)
        
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "島会議"
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
        initalMeetingList()
        
        super.lockView()
        

    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {}
    
    private func addSubviews() {
        view.addSubview(meetingSegments)
        view.addSubview(topImage)
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MeetingCell.self, forCellWithReuseIdentifier:MeetingCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        topImage.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        topImage.autoPinEdge(toSuperviewEdge: .left)
        topImage.autoPinEdge(toSuperviewEdge: .right)
        
        
        meetingSegments.selectedSegmentIndex = 0
        meetingSegments.translatesAutoresizingMaskIntoConstraints = false
        meetingSegments.autoPinEdge(.top, to: .bottom, of: topImage, withOffset: 1)
        meetingSegments.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        meetingSegments.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: meetingSegments, withOffset: 3)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "島会議"
    }
    
    func initalMeetingList () {
        // 非同期処理
        let service = MeetingService.instance
        
        service.getEventMeeting(callback: {
            meetings in
            self.meetingList = meetings
            self.collectionView.reloadData()
        },
                                onError: {
                                    error in
                                    self.showError(error as! String)
        })
    }
}

// MARK: - UITableViewDataSource
extension IslandViewController: UICollectionViewDataSource {
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingCell.id, for: indexPath ) as? MeetingCell
        {
            cell.configureView(meeting: meetingList[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IslandViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        return IslandCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print (handler.view?.description ?? "")
        let controller = TalkListViewController(meeting: ((handler.view) as! MeetingCell).meetingInfo!)
        self.navigationItem.title = "戻る"
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension IslandViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) )
        let cellSize: CGSize = CGSize( width: width, height:30 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 1)
    }
}
