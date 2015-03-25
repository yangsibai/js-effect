###
    reference:
    + http://viget.com/extend/2666
    + http://www.paulirish.com/2011/requestanimationframe-for-smart-animating/
###
class Effect
    constructor: (elem, init_src, cb)->
        @_initMethod()
        @parent = elem
        @parent.style.position = 'relative'
        @parent.style.overflow = 'hidden'

        @_insertImg init_src,
            position: 'absolute'
            left: '0%'
            top: '0%'
        , (img)=>
            @current = img
            cb() if typeof(cb) is 'function'

        @_delta = 0.2

    _getTime: ->
        if window.performance.now
            return window.performance.now()
        return Date.now()

    _initMethod: ->
        lastTime = 0
        vendors = [
            'webkit'
            'moz'
        ]
        x = 0
        while x < vendors.length and !window.requestAnimationFrame
            window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame']
            window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] or window[vendors[x] + 'CancelRequestAnimationFrame']
            ++x
        if !window.requestAnimationFrame

            window.requestAnimationFrame = (callback, element) ->
                currTime = (new Date).getTime()
                timeToCall = Math.max(0, 16 - (currTime - lastTime))
                id = window.setTimeout((->
                    callback currTime + timeToCall
                    return
                ), timeToCall)
                lastTime = currTime + timeToCall
                id

        if !window.cancelAnimationFrame

            window.cancelAnimationFrame = (id) ->
                clearTimeout id
                return

    _insertImg: (src, style, cb)->
        img = document.createElement('img')
        img.style.width = '100%'
        img.style.height = '100%'
        img.style.position = 'absolute'
        img.style.opacity = '1'
        img.src = src
        for k of style
            img.style[k] = style[k]
        img.onload = =>
            img.onload = null
            @parent.appendChild(img)
            cb img

    _finish: ->
        @parent.removeChild(@current)
        @animate.style.left = '0%'
        @animate.style.top = '0%'
        @animate.style.opacity = '1'
        @current = @animate
        @animating = false

    _percentAdd: (per, delta)->
        p = parseFloat(per.substring(0, per.length - 1))
        return (p + delta) + '%'

    _percentToFloat: (per)->
        return parseFloat(per.substring(0, per.length - 1)) / 100.0

    _hasFinishAnimate: ->
        return @animate.style.top is '0%' and @animate.style.left is '0%' and @animate.style.opacity is '1'

    _moveCurrentImg: (name, delta)->
        @current.style[name] = @_percentAdd(@current.style[name], delta)

    _moveAnimateImg: (name, delta)->
        @animate.style[name] = @_percentAdd(@animate.style[name], delta)

    _changeStyle: (elem, name, delta)->
        elem.style[name] = @_percentAdd(elem.style[name], delta)

    _animate: (src, style, func, stopFunc, onAnimateFinished)->
        unless @animating
            @animating = true
            @_insertImg src, style, (img)=>
                @animate = img
                startTime = @_getTime()
                endTime = 0
                lo = =>
                    if stopFunc()
                        @_finish()
                        onAnimateFinished() if typeof(onAnimateFinished) is 'function'
                        return
                    endTime = @_getTime()
                    diff = endTime - startTime
                    func(diff * @_delta)
                    startTime = @_getTime()
                    requestAnimationFrame lo

                requestAnimationFrame lo

    pushLeft: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            left: '100%'
            top: '0%'
        , (delta)=>
            distance = -@_distance('left', delta)

            @_moveCurrentImg('left', distance)
            @_moveAnimateImg('left', distance)
        , =>
            return @_percentToFloat(@animate.style.left) <= 0
        , onAnimateFinished

    pushRight: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            left: '-100%'
            top: '0%'
        , (delta)=>
            distance = @_distance('left', delta)
            @_moveCurrentImg('left', distance)
            @_moveAnimateImg('left', distance)
        , =>
            return @_percentToFloat(@animate.style.left) >= 0
        , onAnimateFinished

    pushDown: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , (delta)=>
            distance = @_distance('top', delta)
            @_moveCurrentImg('top', distance)
            @_moveAnimateImg('top', distance)
        , =>
            return @_percentToFloat(@animate.style.top) >= 0
        , onAnimateFinished

    pushUp: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , (delta)=>
            distance = -@_distance('top', delta)
            @_moveCurrentImg('top', distance)
            @_moveAnimateImg('top', distance)
        , =>
            return @_percentToFloat(@animate.style.top) <= 0
        , onAnimateFinished

    slideUp: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , (delta)=>
            @_moveAnimateImg('top', -@_distance('top', delta))
        , =>
            return @_percentToFloat(@animate.style.top) <= 0
        , onAnimateFinished

    slideDown: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , (delta)=>
            @_moveAnimateImg('top', @_distance('top', delta))
        , =>
            return @_percentToFloat(@animate.style.top) >= 0
        , onAnimateFinished

    _distance: (style, delta)->
        return Math.min(delta, Math.abs(@_percentToFloat(@animate.style[style]) * 100))

    slideLeft: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '100%'
        , (delta)=>
            @_moveAnimateImg('left', -@_distance('left', delta))
        , =>
            return @_percentToFloat(@animate.style.left) <= 0
        , onAnimateFinished

    slideRight: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '-100%'
        , (delta)=>
            @_moveAnimateImg('left', @_distance('left', delta))
        , =>
            return @_percentToFloat(@animate.style.left) >= 0
        , onAnimateFinished

    expand: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '50%'
            left: '50%'
            width: '0'
            height: '0'
        , (delta)=>
            @_changeStyle(@animate, 'width', delta)
            @_changeStyle(@animate, 'height', delta)
            @_changeStyle(@animate, 'top', -(delta / 2))
            @_changeStyle(@animate, 'left', -(delta / 2))
        , =>
            return @_percentToFloat(@animate.style.top) <= 0
        , onAnimateFinished

    fadeIn: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '0%'
            opacity: '0'
        , =>
            delta = 0.0334
            @animate.style.opacity = parseFloat(@animate.style.opacity) + delta
        , =>
            return parseFloat(@animate.style.opacity) >= 1
        , onAnimateFinished

    direct: (imgURL, onFinished)->
        @current.src = imgURL
        onFinished() if typeof(onFinished) is 'function'

window.Effect = Effect
