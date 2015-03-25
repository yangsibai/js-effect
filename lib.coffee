_createImg = (src, style, cb)->
    img = document.createElement('img')
    img.style.width = '100%'
    img.style.height = '100%'
    img.src = src
    for k of style
        img.style[k] = style[k]
    img.onload = ->
        cb img

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

        _createImg options.src,
            position: 'absolute'
            left: '0%'
            top: '0%'
        , (img)=>
            @current = img
            @parent.appendChild(img)

    pushLeft: (imgURL)->
        _createImg imgURL,
            left: '100%'
            top: '0%'
        , (newImg)=>
            @parent.appendChild(newImg)

            delta = 1

            finish = =>
                @parent.removeChild(@current)
                @current = newImg

            func = =>
                if perfectToDecimal(@current.style.left) <= -1
                    finish()
                    return
                @current.style.left = percentAdd(@current.style.left, -delta)
                newImg.style.left = percentAdd(newImg.style.left, -delta)
                requestAnimationFrame(func)

            requestAnimationFrame(func)

    pushRight: (imgURL)->
        _createImg imgURL,
            position: 'absolute'
            left: '-100%'
            top: '0%'
        , (newImg)=>
            @parent.appendChild(newImg)

            finish = =>
                @parent.removeChild(@current)
                @current = newImg

            delta = 1

            func = =>
                if perfectToDecimal(@current.style.left) >= 1
                    finish()
                    return
                @current.style.left = percentAdd(@current.style.left, delta)
                newImg.style.left = percentAdd(newImg.style.left, delta)
                requestAnimationFrame(func)

            requestAnimationFrame func

    pushDown: (imgURL)->
        _createImg(imgURL)
        _createImg imgURL,
            position: 'absolute'
            top: '-100%'
            left: '0%'
        , (newImg)=>
            @parent.appendChild(newImg)

            finish = =>
                @parent.removeChild(@current)
                @current = newImg

            delta = 1

            func = =>
                if perfectToDecimal(@current.style.top) >= 1
                    finish()
                    return
                @current.style.top = percentAdd(@current.style.top, delta)
                newImg.style.top = percentAdd(newImg.style.top, delta)
                requestAnimationFrame(func)

            requestAnimationFrame func

    pushUp: (imgURL)->
        _createImg imgURL,
            position: 'absolute'
            top: '100%'
            left: '0%'
        , (newImg)=>
            @parent.appendChild(newImg)

            finish = =>
                @parent.removeChild(@current)
                @current = newImg

            delta = 1

            func = =>
                if perfectToDecimal(@current.style.top) <= -1
                    finish()
                    return
                @current.style.top = percentAdd(@current.style.top, -delta)
                newImg.style.top = percentAdd(newImg.style.top, -delta)
                requestAnimationFrame func

            requestAnimationFrame func

window.Effect = Effect
