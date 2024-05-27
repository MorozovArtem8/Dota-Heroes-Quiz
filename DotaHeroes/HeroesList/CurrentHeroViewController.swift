import UIKit

class CurrentHeroViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            guard let image else {return}
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image else {return}
        
        imageView.image = image
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
