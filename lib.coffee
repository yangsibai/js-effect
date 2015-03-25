_createImg = (src)->
    img = document.createElement('img')
    img.style.width = '100%'
    img.style.height = '100%'
    img.src = src
    return img

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

        img = _createImg(options.src)
        img.style.position = 'absolute'
        img.style.left = '0%'
        img.style.top = '0%'
        @current = img
        @parent.appendChild(img)

    pushLeft: (imgURL)->
        newImg = _createImg(imgURL)
        newImg.style.position = 'absolute'
        newImg.style.left = '100%'
        newImg.style.top = '0%'
        @parent.appendChild(newImg)

#        @current.style.marginLeft = '0%'

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
        newImg = _createImg(imgURL)
        newImg.style.position = 'absolute'
        newImg.style.left = '-100%'
        newImg.style.top = '0%'
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
        newImg = _createImg(imgURL)
        newImg.style.position = "absolute"
        newImg.style.top = '-100%'
        newImg.style.left = '0%'
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


window.Effect = Effect
