import UIKit
import PureLayout


@objc(IsLandViewController)
class IslandViewController: UIViewController {
    
    
    // MARK: - Properties
    var islands: [Island]
    
    // MARK: - View Elements
    let topImage: UIImageView
    let buttonPublic: UIButton
    let buttonPrivate: UIButton
    
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init() {
        islands = [Island]()
        self.topImage = UIImageView.newAutoLayout()
        self.topImage.image = UIImage(named: "penginland")
        
        self.buttonPublic = UIButton.newAutoLayout()
        self.buttonPublic.setTitle("public", for: UIControlState.normal)
        self.buttonPublic.setTitleColor(UIColor.black, for: .normal)
        self.buttonPublic.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        
        self.buttonPrivate = UIButton.newAutoLayout()
        self.buttonPrivate.setTitle("Private", for: UIControlState.normal)
        self.buttonPrivate.backgroundColor = UIColor.gray
        
        self.buttonPrivate.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "島会議"
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
        initalIsland()

    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {}
    
    private func addSubviews() {
        view.addSubview(topImage)
        view.addSubview(buttonPublic)
        view.addSubview(buttonPrivate)
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IslandCell.self, forCellWithReuseIdentifier:IslandCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        topImage.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        topImage.autoPinEdge(toSuperviewEdge: .left)
        topImage.autoPinEdge(toSuperviewEdge: .right)
        
        buttonPublic.autoPinEdge(.top, to: .bottom, of: topImage )
        buttonPublic.autoPinEdge(.left, to: .left, of: topImage )
        buttonPublic.autoSetDimension(.height, toSize: 40)
        buttonPublic.autoSetDimension(.width, toSize: UIScreen.main.bounds.size.width / 2)
        
        buttonPrivate.autoPinEdge(.top, to: .top, of: buttonPublic )
        buttonPrivate.autoPinEdge(.left, to: .right, of: buttonPublic )
        buttonPrivate.autoPinEdge(.right, to: .right, of: topImage )
        buttonPrivate.autoSetDimension(.height, toSize: 40)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: buttonPublic)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "島会議"
    }
    


    func initalIsland () {
        let queue = OperationQueue()
        queue.addOperation() {
            // 非同期処理
            let service = IslandService.instance
            let keys = ["nothing"]
            
            self.islands = service.search(keys: keys)
            // 非同期処理のコールバック
            OperationQueue.main.addOperation() {
                self.collectionView.reloadData()
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension IslandViewController: UICollectionViewDataSource {
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return islands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IslandCell.id, for: indexPath ) as? IslandCell
        {
            cell.configureView(island: islands[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IslandViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        return IslandCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print (handler.view)
        let controller = TalkListViewController(island: ((handler.view) as! IslandCell).island!)
        self.navigationItem.title = "..."
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
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
