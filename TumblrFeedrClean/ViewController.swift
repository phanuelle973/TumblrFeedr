//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []



//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
//        tableView.refreshControl = refreshControl
//        
////        let alert = UIAlertController(title: "Loaded!", message: "Your Tumblr feed view controller is working 🎉", preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(alert, animated: true, completion: nil)
//
//        
//        fetchPosts()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl


        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")

        fetchPosts()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let alert = UIAlertController(title: "Loaded!", message: "Your Tumblr feed view controller is working 🎉", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    self?.posts = posts
                    self?.tableView.reloadData()

                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    @objc func refreshPosts() {
        fetchPosts()
        tableView.refreshControl?.endRefreshing()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = posts[indexPath.row]
//        guard let postUrl = post.postUrl else { return } // make sure your Post model has this
//
//        if let url = URL(string: postUrl) {
//            UIApplication.shared.open(url)
//        }
//    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.summaryLabel.text = post.summary

        if let photo = post.photos.first {
            ImagePipeline.shared.loadImage(with: photo.originalSize.url) { result in
                switch result {
                case .success(let response):
                    cell.postImageView.image = response.image
                case .failure(let error):
                    print("❌ Image loading failed: \(error)")
                }
            }
        }

        return cell
    }
}

