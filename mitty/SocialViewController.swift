import UIKit
import PureLayout


@objc(SocialViewController)
class SocialViewController: MittyViewController {
    
    
    // MARK: - Properties
    var contactList: [Contactee]
    
    // MARK: - View Elements
    let topImage: UIImageView
    
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init() {
        contactList = [Contactee]()
        self.topImage = UIImageView.newAutoLayout()
        self.topImage.image = UIImage(named: "connect")
        
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
        
        super.autoCloseKeyboard()
        
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "つながり"
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
        initalContactList()
        
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {}
    
    private func addSubviews() {
        view.addSubview(topImage)
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactInfoCell.self, forCellWithReuseIdentifier:ContactInfoCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        topImage.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        topImage.autoPinEdge(toSuperviewEdge: .left)
        topImage.autoPinEdge(toSuperviewEdge: .right)
        
        
        collectionView.autoPinEdge(.top, to: .bottom, of: topImage)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "つながり"
    }
    
    
    
    func initalContactList () {

        SocialContactService.instance.getContacteeList(onComplete: {
            list in
            self.contactList = list
            self.collectionView.reloadData()
        }, onError: {
            error in
            
        })
        
        
    }
    
}

// MARK: - UITableViewDataSource
extension SocialViewController: UICollectionViewDataSource {
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactInfoCell.id, for: indexPath ) as? ContactInfoCell
        {
            cell.configureView(contact: contactList[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SocialViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        return ContactInfoCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        
        let contact = ((handler.view) as! ContactInfoCell).contact!
        
        handler.view?.isUserInteractionEnabled = false
        let vc = ProfileViewController()
        vc.mittyId = contact.profile.mittyId
        
        self.navigationController?.pushViewController(vc, animated: true)
        handler.view?.isUserInteractionEnabled = true
    }
}

extension SocialViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) )
        let cellSize: CGSize = CGSize( width: width, height:60 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
