/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import UIKit

class PagedTutorialViewController: UIPageViewController {
  var pageControl: UIPageControl!

  let pageCount = 5

  override func viewDidLoad() {
    super.viewDidLoad()

    setViewControllers([tutorialStepForPage(0)], direction: .Forward, animated: false, completion: nil)
    dataSource = self

    let pageControlHeight: CGFloat = 50
    pageControl = UIPageControl(frame: CGRect(x: 0, y: CGRectGetHeight(view.frame) - pageControlHeight, width: CGRectGetWidth(view.frame), height: pageControlHeight))
    pageControl.numberOfPages = pageCount
    pageControl.currentPage = 0

    // uber solution - connect the action
    pageControl.addTarget(self, action: #selector(PagedTutorialViewController.pageControlChanged(_:)), forControlEvents: .ValueChanged)

    view.addSubview(pageControl)

    delegate = self
  }

  // uber solution - action method
  func pageControlChanged(pageControl: UIPageControl) {
    // get the current and upcoming page numbers
    let currentTutorialPage = (viewControllers![0] as! TutorialStepViewController).page
    let upcomingTutorialPage = pageControl.currentPage

    // what direction are we moving in?
    let direction: UIPageViewControllerNavigationDirection = upcomingTutorialPage < currentTutorialPage ? .Reverse : .Forward

    // set the new page, animated!
    setViewControllers([tutorialStepForPage(upcomingTutorialPage)],
      direction: direction, animated: true, completion: nil)
  }

  private func tutorialStepForPage(inPage: Int) -> TutorialStepViewController {
    let tutorialStep = storyboard!.instantiateViewControllerWithIdentifier("TutorialStepViewController") as! TutorialStepViewController
    let page = min(max(0, inPage), pageCount-1)
    tutorialStep.page = page
    tutorialStep.backgroundImage = UIImage(named: "bg_\(page+1)")
    tutorialStep.iconImage = UIImage(named: "icon_\(page+1)")

    if page == 0 {
      tutorialStep.text = "PetShare is a pet photo sharing community."
    } else if page == 1 {
      tutorialStep.text = "Take pictures of your pet, and add filters or clipart to help them shine."
    } else if page == 2 {
      tutorialStep.text = "Share your photos via Facebook, email, Twitter, or instant message."
    } else if page == 3 {
      tutorialStep.text = "Rate other photos, give hearts, and follow pets you adore!"
    } else if page == 4 {
      tutorialStep.text = "Set up a profile for your pet, show past photos, and let fans follow."
    }

    return tutorialStep
  }
}

extension PagedTutorialViewController: UIPageViewControllerDataSource {
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    if let currentTutorialPage = viewController as? TutorialStepViewController {
      if currentTutorialPage.page < pageCount - 1 {
        return tutorialStepForPage(currentTutorialPage.page + 1)
      }
    }
    return nil
  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    if let currentTutorialPage = viewController as? TutorialStepViewController {
      if currentTutorialPage.page > 0 {
        return tutorialStepForPage(currentTutorialPage.page - 1)
      }
    }
    return nil
  }

  /* Code to activate the built-in page control */
  /*
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pageCount
  }

  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    if let currentTutorialPage = pageViewController.viewControllers[0] as? TutorialStepViewController {
      return currentTutorialPage.page
    }
    return 0
  }
  */
}

extension PagedTutorialViewController: UIPageViewControllerDelegate {
  func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let currentTutorialPage = pageViewController.viewControllers![0] as? TutorialStepViewController {
      pageControl.currentPage = currentTutorialPage.page
    }
  }
}
