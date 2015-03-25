class Effect
    constructor: (elem, init_src, cb)->
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
            @parent.appendChild(img)
            cb img

    _finish: ->
        @parent.removeChild(@current)
        @current = @animate
        @animating = false

    _percentAdd: (per, delta)->
        p = parseFloat(per.substring(0, per.length - 1))
        return (p + delta) + '%'

    _hasFinishAnimate: ->
        return @animate.style.top is '0%' and @animate.style.left is '0%' and @animate.style.opacity is '1'

    _moveCurrentImg: (name, delta)->
        @current.style[name] = @_percentAdd(@current.style[name], delta)

    _moveAnimateImg: (name, delta)->
        @animate.style[name] = @_percentAdd(@animate.style[name], delta)

    _changeStyle: (elem, name, delta)->
        elem.style[name] = @_percentAdd(elem.style[name], delta)

    _animate: (src, style, func, onAnimateFinished)->
        unless @animating
            @animating = true
            @_insertImg src, style, (img)=>
                @animate = img
                lo = =>
                    if @_hasFinishAnimate()
                        @_finish()
                        onAnimateFinished() if typeof(onAnimateFinished) is 'function'
                        return
                    func()
                    requestAnimationFrame lo

                requestAnimationFrame lo

    pushLeft: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            left: '100%'
            top: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('left', -delta)
            @_moveAnimateImg('left', -delta)
        , onAnimateFinished

    pushRight: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            left: '-100%'
            top: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('left', delta)
            @_moveAnimateImg('left', delta)
        , onAnimateFinished

    pushDown: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('top', delta)
            @_moveAnimateImg('top', delta)
        , onAnimateFinished

    pushUp: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('top', -delta)
            @_moveAnimateImg('top', -delta)
        , onAnimateFinished

    slideUp: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , =>
            delta = 1
            @_moveAnimateImg('top', -delta)
        , onAnimateFinished

    slideDown: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , =>
            delta = 1
            @_moveAnimateImg('top', delta)
        , onAnimateFinished

    slideLeft: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '100%'
        , =>
            delta = 1
            @_moveAnimateImg('left', -delta)
        , onAnimateFinished

    slideRight: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '-100%'
        , =>
            delta = 1
            @_moveAnimateImg('left', delta)
        , onAnimateFinished

    expand: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '50%'
            left: '50%'
            width: '0'
            height: '0'
        , =>
            delta = 1
            @_changeStyle(@animate, 'width', delta * 2)
            @_changeStyle(@animate, 'height', delta * 2)
            @_changeStyle(@animate, 'top', -delta)
            @_changeStyle(@animate, 'left', -delta)
        , onAnimateFinished

    fadeIn: (imgURL, onAnimateFinished)->
        @_animate imgURL,
            top: '0%'
            left: '0%'
            opacity: '0'
        , =>
            delta = 0.05
            @animate.style.opacity = parseFloat(@animate.style.opacity) + delta
        , onAnimateFinished

    direct: (imgURL, onFinished)->
        @current.src = imgURL
        onFinished() if typeof(onFinished) is 'function'

window.Effect = Effect
