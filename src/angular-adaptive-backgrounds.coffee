angular.module 'mb-adaptive-backgrounds', ['ng']

.provider 'adaptiveBackgroundsOptions', ->
  # Include RGBaster - https://github.com/briangonzalez/rgbaster.js
  `!function(n){"use strict";var t=function(){return document.createElement("canvas").getContext("2d")},e=function(n,e){var a=new Image,o=n.src||n;"data:"!==o.substring(0,5)&&(a.crossOrigin="Anonymous"),a.onload=function(){var n=t("2d");n.drawImage(a,0,0);var o=n.getImageData(0,0,a.width,a.height);e&&e(o.data)},a.src=o},a=function(n){return["rgb(",n,")"].join("")},o=function(n){return n.map(function(n){return a(n.name)})},r=5,i=10,c={};c.colors=function(n,t){t=t||{};var c=t.exclude||[],u=t.paletteSize||i;e(n,function(e){for(var i=n.width*n.height||e.length,m={},s="",d=[],f={dominant:{name:"",count:0},palette:Array.apply(null,new Array(u)).map(Boolean).map(function(){return{name:"0,0,0",count:0}})},l=0;i>l;){if(d[0]=e[l],d[1]=e[l+1],d[2]=e[l+2],s=d.join(","),m[s]=s in m?m[s]+1:1,-1===c.indexOf(a(s))){var g=m[s];g>f.dominant.count?(f.dominant.name=s,f.dominant.count=g):f.palette.some(function(n){return g>n.count?(n.name=s,n.count=g,!0):void 0})}l+=4*r}if(t.success){var p=o(f.palette);t.success({dominant:a(f.dominant.name),secondary:p[0],palette:p})}})},n.RGBaster=n.RGBaster||c}(window);`

  # Default options
  options =
    imageClass: null
    exclude: ['rgb(0,0,0)', 'rgba(255,255,255)']
    lumaClasses:
      light: 'ab-light-background'
      dark: 'ab-dark-background'

  return {
    set: (userOptions) ->
      angular.extend options, userOptions

    $get: ->
      return options
  }

.directive 'adaptiveBackground', ($window, adaptiveBackgroundsOptions) ->
  options = adaptiveBackgroundsOptions

  getCSSBackground = (raw) ->
    $window.getComputedStyle(raw, null)
      .getPropertyValue('background-image')
      # Strip down to just the URL itself
      .replace('url(', '')
      .replace(')', '')

  # http://en.wikipedia.org/wiki/YIQ
  digitsRegexp = /\d+/g
  getYIQ = (color) ->
    rgb = color.match digitsRegexp
    ((rgb[0] * 299) + (rgb[1] * 587) + (rgb[2] * 114)) / 1000

  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      rawElement = element[0]

      useCSSBackground = (el) ->
        el.tagName isnt 'IMG'

      findImage = ->
        # Prioritize local attribute over global config
        imageClass = attrs.abImageClass or options.imageClass

        if imageClass?
          # Try finding an element with the given class
          elementWithClass = rawElement.querySelector('.' + imageClass)
          if elementWithClass?
            return angular.element elementWithClass

        # Default to the first img
        angular.element element.find('img')[0]

      setColors = (colors) ->
        # Set the background color
        element.css 'backgroundColor', colors.dominant

        # Determine the brightness
        yiq = getYIQ colors.dominant
        if yiq <= 128
          element.addClass options.lumaClasses.dark
          element.removeClass options.lumaClasses.light
        else
          element.addClass options.lumaClasses.light
          element.removeClass options.lumaClasses.dark

        # Expose colors to scope
        colors.backgroundYIQ = yiq
        scope.adaptiveBackgroundColors = colors

      adaptBackground = (image) ->
        # Get the colors!
        RGBaster.colors image,
          paletteSize: 20
          exclude: options.exclude
          success: setColors

      childElement = findImage()
      rawChildElement = childElement[0]

      if useCSSBackground(rawChildElement)
        adaptBackground getCSSBackground(rawChildElement)

      else
        handleImg = ->
          if rawChildElement.src
            adaptBackground rawChildElement

        # If the image changes, set the background again
        childElement.on 'load', handleImg

        scope.$on '$destroy', ->
          childElement.off 'load', handleImg

        handleImg()
  }
