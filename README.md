#StarWarsAnimatedTransitioning

UIViewController animated transitioning mimicking the Star Wars scene transitions using the custom animated transition APIs added in iOS 7.
It uses CALayer animations and masks so transitions do not break layout and dynamic/animated content in the view controllers involved.

![anim](https://cloud.githubusercontent.com/assets/5302709/5523106/e2b171c2-89cc-11e4-8954-ebb4821ef569.gif)

This is an experimentation with Core Animation during which I learned quite a few tricks 'till deciding the current implementation and APIs to use.
I encourage everyone to familiarize themselves with masks, anchor points and transforms of CALayers!

Feedback is welcome and greatly appreciated!

##Usage

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

##Future Updates:

* Radial transition style
* Faded edges



#License
StarWarsAnimatedTransitioning is MIT-licensed.
