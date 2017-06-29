import UIKit
import PureLayout
import Alamofire

class TalkingCell: UICollectionViewCell {
    static let id = "talking-cell"
    
    // MARK: - View Elements
    var talk : Talk!
    
    let avatarIcon: UIImageView = {
        let a = UIImageView.newAutoLayout()
        return a
    } ()
    
    let name: UILabel = {
        let l = UILabel.newAutoLayout()
        l.numberOfLines = 1
        return l
    } ()

    let talking: UILabel = {
        let l = UILabel.newAutoLayout()
        l.numberOfLines = 0
        return l
    } ()
    
    let time: UILabel = {
        let l = UILabel.newAutoLayout()
        l.numberOfLines = 1
        return l
    } ()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(avatarIcon)
        contentView.addSubview(talking)
        contentView.addSubview(time)
        
    }
    
    private func configureSubviews() {
        
    }
    
    private func addConstraints() {
        avatarIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        avatarIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        avatarIcon.autoSetDimension(.height, toSize: 40)
        avatarIcon.autoSetDimension(.width, toSize: 40)

        name.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        name.autoPinEdge(.left, to:.right, of: avatarIcon, withOffset: 15)
        name.autoSetDimension(.width, toSize: 100)
        name.autoSetDimension(.height, toSize: 30)
        
        time.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        time.autoPinEdge(.left, to:.right, of: name, withOffset: 15)
        time.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        time.autoSetDimension(.height, toSize: 30)

        
        talking.autoPinEdge(.top, to:.bottom, of: name, withOffset:10)
        talking.autoPinEdge(.left, to:.right, of: avatarIcon, withOffset:10)
        talking.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
    }
    
    func configureView(talk: Talk) {
        
        self.talk = talk
        
        name.numberOfLines = 1
        name.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        name.text = "mittyId\(talk.speakerId)"
        
        // TODO
        avatarIcon.image = UIImage (named: "pengin1")
        talking.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        talking.text = self.talk.speaking

        time.text = talk.speakTime.time
        time.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        self.talk.height = talking.frame.height + 40
        
        let uid = String(talk.speakerId)
        
        UserService.instance.getUserInfo(id: uid) { (user, ok) in
            if !ok {
                return
            }
            self.name.text = "\(user!.userName)"
            if (user!.icon != "") {
                
                DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
                if let url = URL(string: user!.icon) {
                    self.avatarIcon.af_setImage(withURL:url, placeholderImage: UIImage(named: "downloading"), completion : { image in
                        if (image.result.isSuccess) {
                            self.avatarIcon.image = image.result.value
                        }
                    }
                    )
                }
            }
        }

    }
}
