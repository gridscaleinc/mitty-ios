import UIKit
import PureLayout

class EventCell: UICollectionViewCell {
    static let id = "journey-search-result-cell"
    
    // MARK: - View Elements
    var event : EventInfo?
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]
    
    
    var form = MQForm.newAutoLayout()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        
        
    }
    
    func configureView(event: EventInfo) {
        
        self.event = event
        form = MQForm.newAutoLayout()
        self.addSubview(form)
        form.autoPinEdgesToSuperviewEdges()

        let section = Section(name: "eventcell", view: UIView.newAutoLayout())
        section.layout {
            s in
            s.fillParent()
        }
        form +++ section
        
        // 誰かポストしたのか
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
        }
        
        let publisherIcon = MQForm.img(name: "pushlisherIcon", url: "pengin4")
        row +++ publisherIcon.width(30).height(30)
        
        let publisher = MQForm.label(name: "publisher", title: event.publisherName)
        row +++ publisher.layout{
            pub in
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = MittyColor.healthyGreen
        }
        
        let published = MQForm.label(name: "days", title: "\(event.publishedDays)days ago.")
        row +++ published.layout{
            pub in
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = UIColor.lightGray
        }
        
        section <<< row
        
        // タイトルを表示
        // logoがある場合ロゴを表示
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(75)
        }
        let col = Col.BottomUpAligned().layout {
            c in
            c.height(75).width(25)
        }
        col +++ MQForm.label(name: "likes1", title: "🔺").width(25).height(25)
        col +++ MQForm.label(name: "likes2", title: String(describing: event.likes)).width(25).height(25).layout {
            l in
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            label.textAlignment = .center
        }
        
        col +++ MQForm.label(name: "likes3", title: "🔻").width(25).height(25)
        row +++ col
        
        row +++ MQForm.img(name: "eventLogo", url: "timesquare").width(50).height(50)
        let titleLabel = MQForm.label(name: "titleLabel", title: event.title).layout {t in
            t.label.numberOfLines = 2
            t.label.font = UIFont.boldSystemFont(ofSize: 18)
            t.rightMost().height(50)
            t.label.textColor = MittyColor.healthyGreen
        }
        row +++ titleLabel
        section <<< row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(UIScreen.main.bounds.width - 30)
        }
        // imageがある場合、イメージを表示
        let itemImage = MQForm.img(name: "eventImage", url: event.coverImageUrl).layout {
            img in
            img.fillHolizon().height(UIScreen.main.bounds.width - 30)
            if event.coverImage != nil {
                img.image.image = event.coverImage
            }
        }
        row +++ itemImage
        section <<< row
        
        // 日付情報を設定
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
        let endTimeLabel = UILabel.newAutoLayout()
        endTimeLabel.text = event.duration()
        let timeDuration = Control(name:"duration", view: endTimeLabel).layout {
            l in
            l.fillParent()
            l.label.font = UIFont.systemFont(ofSize: 14)
        }
        row +++ timeDuration
        section <<< row
        
        // 日付情報を設定
        row = Row.LeftAligned()
        let actionLabel = UILabel.newAutoLayout()
        actionLabel.text = event.action
        let actionCtrl = Control(name:"actionLabel", view: actionLabel).layout {
            l in
            l.fillParent()
            l.label.font = UIFont.systemFont(ofSize: 12)
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
            l.label.numberOfLines = 0
        }
        row.layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ actionCtrl
        section <<< row
        
        form.configLayout()
        
    }
    func reloadImages() {
        if let img = event?.coverImage {
            if let iv = form.quest("[name=eventImage]").control()?.image {
                iv.image = img
            }
        }
        
        if let img = event?.eventLogo {
            form.quest("[name=eventLogo]").control()?.image.image = img
        }
        
        if let img = event?.publisherIcon {
            form.quest("[name=pushlisherIcon]").control()?.image.image = img
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
        form.removeFromSuperview()
    }
}
