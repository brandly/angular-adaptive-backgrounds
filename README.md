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
<!-- This <div> will get receive a background color... -->
<div>
  <!-- from this <img> -->
  <img src="cool.jpg" adaptive-background>
</div>
```

## getting fancy

Instead of an `<img>`, you might have a `background-image` on some other element. Just add a `ab-css-background` attribute to make sure it finds the image.

```html
<div>
  <div style="background-image: url('cool.jpg');" adaptive-background ab-css-background></div>
</div>
```

----

Since your markup could get far more complicated in a real example, you can apply the background color to _any_ parent element, simply by setting an `ab-parent-class` attribute.

```html
<!-- This guy gets the background-color -->
<div class="the-chosen-one">
  <!-- but not these guys -->
  <div>
    <div>
      <!-- since we set the ab-parent-class -->
      <img src="cool.jpg" adaptive-background ab-parent-class="the-chosen-one">
    </div>
  </div>
</div>
```

----

If you have elements all over your page that need custom parents, instead of setting `ab-parent-class` on each and every `img`, you can set a parent class for your entire app.

```js
myApp.config(function (adaptiveBackgroundsOptionsProvider) {
  adaptiveBackgroundsOptionsProvider.set({
    parentClass: 'the-chosen-one'
  });
});
```

```html
<!-- This guy _still_ gets the background-color -->
<div class="the-chosen-one">
  <div>
    <div>
      <!-- despite not setting any ab-parent-class -->
      <img src="cool.jpg" adaptive-background>
    </div>
  </div>
</div>
```

## dev

```shell
$ npm install
$ npm start
```
