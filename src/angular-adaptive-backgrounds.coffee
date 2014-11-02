angular.module 'mb-adaptive-backgrounds', ['ng']

.provider 'adaptiveBackgroundsOptions', ->
  # Include RGBaster - https://github.com/briangonzalez/rgbaster.js
  `!function(n){"use strict";var t=function(){return document.createElement("canvas").getContext("2d")},e=function(n,e){var a=new Image,o=n.src||n;"data:"!==o.substring(0,5)&&(a.crossOrigin="Anonymous"),a.onload=function(){var n=t("2d");n.drawImage(a,0,0);var o=n.getImageData(0,0,a.width,a.height);e&&e(o.data)},a.src=o},a=function(n){return["rgb(",n,")"].join("")},o=function(n){return n.map(function(n){return a(n.name)})},r=5,i=10,c={};c.colors=function(n,t){t=t||{};var c=t.exclude||[],u=t.paletteSize||i;e(n,function(e){for(var i=n.width*n.height||e.length,m={},s="",d=[],f={dominant:{name:"",count:0},palette:Array.apply(null,new Array(u)).map(Boolean).map(function(){return{name:"0,0,0",count:0}})},l=0;i>l;){if(d[0]=e[l],d[1]=e[l+1],d[2]=e[l+2],s=d.join(","),m[s]=s in m?m[s]+1:1,-1===c.indexOf(a(s))){var g=m[s];g>f.dominant.count?(f.dominant.name=s,f.dominant.count=g):f.palette.some(function(n){return g>n.count?(n.name=s,n.count=g,!0):void 0})}l+=4*r}if(t.success){var p=o(f.palette);t.success({dominant:a(f.dominant.name),secondary:p[0],palette:p})}})},n.RGBaster=n.RGBaster||c}(window);`

  # Default options
  options =
    parentClass: null
    exclude: ['rgb(0,0,0)', 'rgba(255,255,255)']
    normalizeTextColor: false
    normalizedTextColors:
      light: '#fff'
      dark: '#000'
    lumaClasses:
      light: 'ab-light'
      dark: 'ab-dark'

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

  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      rawElement = element[0]

      useCSSBackground = ->
        attrs.abCssBackground?

      getParent = ->
        # Prioritize local attribute over global config
        parentSelector = attrs.abParentClass or options.parentClass

        if parentSelector
          # Basically walking up the DOM
          parent = element.parent()
          while parent[0] isnt document
            # Looking for this class
            if parent.hasClass parentSelector
              return parent
            parent = parent.parent()

        # Default to first parent
        return element.parent()

      setColors = (dominant, palette) ->
        parent = getParent()
        parent.css 'backgroundColor', dominant

      adaptBackground = (image) ->
        # Get the colors!
        RGBaster.colors image,
          paletteSize: 20
          exclude: options.exclude
          success: (colors) ->
            setColors colors.dominant, colors.palette

      if useCSSBackground()
        adaptBackground getCSSBackground(rawElement)

      else
        handleImg = ->
          adaptBackground rawElement

        # If the image changes, set the background again
        element.on 'load', handleImg

        scope.$on '$destroy', ->
          element.off 'load', handleImg

        handleImg()
  }
