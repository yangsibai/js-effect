perfectToDecimal = (per)->
    return parseFloat(per.substring(0, per.length - 1)) / 100.0

percentAdd = (per, delta)->
    p = parseFloat(per.substring(0, per.length - 1))
    return (p + delta) + '%'

class Effect
    constructor: (options)->
        @parent = options.elem
        @parent.style.position = 'relative'
        @parent.style.overflow = 'hidden'

        @_insertImg options.src,
            position: 'absolute'
            left: '0%'
            top: '0%'
        , (img)=>
            @current = img

    _insertImg: (src, style, cb)->
        img = document.createElement('img')
        img.style.width = '100%'
        img.style.height = '100%'
        img.style.position = 'absolute'
        img.src = src
        for k of style
            img.style[k] = style[k]
        img.onload = =>
            @parent.appendChild(img)
            cb img

    _finish: ->
        @parent.removeChild(@current)
        @current = @animate

    _hasFinishAnimate: ->
        return @animate.style.top is '0%' and @animate.style.left is '0%' and @animate.style.opacity is '1'

    _moveCurrentImg: (name, delta)->
        @current.style[name] = percentAdd(@current.style[name], delta)

    _moveAnimateImg: (name, delta)->
        @animate.style[name] = percentAdd(@animate.style[name], delta)

    _changeStyle: (elem, name, delta)->
        elem.style[name] = percentAdd(elem.style[name], delta)

    _animate: (src, style, func)->
        @_insertImg src, style, (img)=>
            @animate = img
            lo = =>
                if @_hasFinishAnimate()
                    @_finish()
                    return
                func()
                requestAnimationFrame lo

            requestAnimationFrame lo

    pushLeft: (imgURL)->
        @_animate imgURL,
            left: '100%'
            top: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('left', -delta)
            @_moveAnimateImg('left', -delta)

    pushRight: (imgURL)->
        @_animate imgURL,
            left: '-100%'
            top: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('left', delta)
            @_moveAnimateImg('left', delta)

    pushDown: (imgURL)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('top', delta)
            @_moveAnimateImg('top', delta)

    pushUp: (imgURL)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , =>
            delta = 1
            @_moveCurrentImg('top', -delta)
            @_moveAnimateImg('top', -delta)

    slideUp: (imgURL)->
        @_animate imgURL,
            top: '100%'
            left: '0%'
        , =>
            delta = 1
            @_moveAnimateImg('top', -delta)

    slideDown: (imgURL)->
        @_animate imgURL,
            top: '-100%'
            left: '0%'
        , =>
            delta = 1
            @_moveAnimateImg('top', delta)

    slideLeft: (imgURL)->
        @_animate imgURL,
            top: '0%'
            left: '100%'
        , =>
            delta = 1
            @_moveAnimateImg('left', -delta)

    slideRight: (imgURL)->
        @_animate imgURL,
            top: '0%'
            left: '-100%'
        , =>
            delta = 1
            @_moveAnimateImg('left', delta)

    expand: (imgURL)->
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

    fadeIn: (imgURL)->
        @_animate imgURL,
            top: '0%'
            left: '0%'
            opacity: '0'
        , =>
            delta = 0.05
            @animate.style.opacity = parseFloat(@animate.style.opacity) + delta

window.Effect = Effect
