import UIKit
import PureLayout


@objc(TalkListViewController)
class TalkListViewController: UIViewController {
    
    var talkingIsLand : Island!
    
    // MARK: - Properties
    var talkingList: [Talk] = {
        var tks = [Talk]()
        var tk1 = Talk()
        tk1.familyName="黄"
        tk1.mittyId = "domanthan"
        tk1.speaking = "こんにちは,よろしくお願いいたします。"
        tk1.avatarIcon = "pengin"
        
        tks.append(tk1)
        
        tk1 = Talk()
        tk1.familyName="金"
        tk1.mittyId = "dongri"
        tk1.speaking = "こんにちは,よろしくお願いいたします。"
        tk1.avatarIcon = "pengin1"
        tks.append(tk1)
        
        tk1 = Talk()
        tk1.familyName="楊"
        tk1.mittyId = "Yang"
        tk1.speaking = "こんにちは,よろしくお願いいたします。"
        tk1.avatarIcon = "pengin2"
        tks.append(tk1)
        
        tk1 = Talk()
        tk1.familyName="張"
        tk1.mittyId = "choiii"
        tk1.speaking = "こんにちは,よろしくお願いいたします。"
        tk1.avatarIcon = "pengin4"
        tks.append(tk1)
        
        
        return tks
        
    } ()
    
    let topLabel: UILabel
    let talkInputField: UITextField
    let talkSendButton: UIButton
    
    
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init(island: Island) {
        
        self.talkingIsLand = island
        
        self.topLabel = UILabel.newAutoLayout()
        self.topLabel.text = ""
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        talkInputField = UITextField.newAutoLayout()
        talkInputField.text = "input message here"
        
        talkSendButton = UIButton.newAutoLayout()
        talkSendButton.setTitle("送信", for: .normal)
        talkSendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        talkSendButton.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.topLabel.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)        
        self.navigationItem.title = "# " + talkingIsLand.islandName
        
        talkInputField.layer.borderWidth = 1
        let leftPadding = UIView(frame: CGRect(x:0, y:0, width:15, height:40))
        talkInputField.leftView = leftPadding
        talkInputField.leftViewMode = UITextFieldViewMode.always
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
        
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {}
    
    private func addSubviews() {
        view.addSubview(topLabel)
        view.addSubview(collectionView)
        
        view.addSubview(talkInputField)
        view.addSubview(talkSendButton)
        
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TalkingCell.self, forCellWithReuseIdentifier:TalkingCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        topLabel.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        topLabel.autoPinEdge(toSuperviewEdge: .left)
        topLabel.autoPinEdge(toSuperviewEdge: .right)
        topLabel.autoSetDimension(.height, toSize: 2)
        
        
        collectionView.autoPinEdge(.top, to: .bottom, of: topLabel, withOffset: 10)
        
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 90)
        
        
        talkInputField.autoPinEdge(.top, to: .bottom, of: collectionView, withOffset:20 )
        talkInputField.autoPinEdge(toSuperviewEdge: .left, withInset: 20 )
        talkInputField.autoSetDimension(.height, toSize: 40)
        talkInputField.autoSetDimension(.width, toSize: UIScreen.main.bounds.width - 120)
        
        talkSendButton.autoPinEdge(.top, to: .top, of: talkInputField)
        talkSendButton.autoPinEdge(.left, to: .right, of: talkInputField, withOffset: 10)
        talkSendButton.autoSetDimension(.height, toSize: 30)
        talkSendButton.autoSetDimension(.width, toSize: 60)
        
    }
    
}

// MARK: - UITableViewDataSource
extension TalkListViewController: UICollectionViewDataSource {
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talkingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TalkingCell.id, for: indexPath ) as? TalkingCell
        {
            cell.configureView(talk: talkingList[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            return cell
        }
        return IslandCell()
    }
    
}

extension TalkListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) )
        let cellSize: CGSize = CGSize( width: width, height:70 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
