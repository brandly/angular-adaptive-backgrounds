# Angular Adaptive Backgrounds

> Surround a picture with its dominant color using a simple directive

```shell
$ npm install --save angular-adaptive-backgrounds
```

## the lowdown

This directive is essentially extracting the dominant color from an image and applying that color to its parent's background. Here's the most simple example:

```html
<!-- Load the script after AngularJS -->
<script src="angular.js"></script>
<script src="angular-adaptive-backgrounds.js"></script>
```

```js
// Make sure your app depends on this module
var myApp = angular.module('myApp', ['mb-adaptive-backgrounds']);
```

```html
<!-- This guy will get receive a background color... -->
<div adaptive-background>
  <!-- from this image -->
  <img src="cool.jpg">
</div>
```

## getting fancy

Since your markup could get far more complicated in a real example, `adaptive-background` will dig through its descendents for the first `img` it can find.

```html
<div adaptive-background>
  <div>
    <div>
      <img src="cool.jpg">
    </div>
  </div>
</div>
```

But if you have multiple images descending from your `adaptive-background`, it might find the wrong one! Fortunately, you can specify a class name.

```html
<div adaptive-background ab-image-class="the-chosen-one">
  <div>
    <div>
      <!-- It will skip right past this image -->
      <img src="not-cool.jpg">
    </div>
    <div>
      <!-- and grab a color from this image -->
      <img src="cool.jpg" class="the-chosen-one">
    </div>
  </div>
</div>
```

In certain cases, you might want to specify a class name for your _entire app_, instead of repeatedly setting `ab-image-class`.

```js
myApp.config(function (adaptiveBackgroundsOptionsProvider) {
  adaptiveBackgroundsOptionsProvider.set({
    imageClass: 'the-chosen-one'
  });
});
```

```html
<!-- Even without setting ab-image-class... -->
<div adaptive-background>
  <div>
    <div>
      <img src="not-cool.jpg">
    </div>
    <div>
      <!-- it will still find this image -->
      <img src="cool.jpg" class="the-chosen-one">
    </div>
  </div>
</div>
```

Instead of an `img` element, you might have a `background-image` on some other element. Have no fear. Simply ensure you've set a parent class, either by `ab-image-class` or a global `config`.

```html
<div adaptive-background ab-image-class="the-chosen-one">
  <div style="background-image: url('cool.jpg');" class="the-chosen-one"></div>
</div>
```

## dev

```shell
$ npm install
$ npm start
```
