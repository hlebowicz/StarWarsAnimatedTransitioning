StarWarsAnimatedTransitioning
=============================

UIViewController animated transitioning mimicking the Star Wars scene transitions using the custom animated transition APIs added in iOS 7.
It uses CALayer animations and masks so transitions do not break layout and dynamic/animated content in the view controllers involved.

This is an experimentation with CALayer during which I learned quite a few tricks 'till deciding the final(for now!) version and APIs used.
I encourage everyone to familiarize themselves with masks, anchor points and transforms of CALayers!

Usage
-----
In order to make the system use a custom animated transitioning class you have to set the presented controller's modalPresentationStyle and transitioningDelegate properties:

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  if segue.identifier == "PresentSecondController" {
    let secondController = segue.destinationViewController as UIViewController
    secondController.modalPresentationStyle = .Custom
    secondController.transitioningDelegate = self
  }
}
```

In the UIViewControllerTransitioningDelegate implementation pass StarWarsAnimatedTransitioning and set it's properties to depending on presentation operation and directions.

```swift
func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
  let animator = StarWarsAnimatedTransitioning()
  animator.transitionOperation = .Present
  animator.transitionDirection = .Right

  return animator
}

func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
  let animator = StarWarsAnimatedTransitioning()

  animator.transitionOperation = .Dismiss
  animator.transitionDirection = .Up

  return animator
}

```

Future Updates:
---------------
* Radial transition style
* Faded edges
