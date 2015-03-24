_createImg = (src)->
    img = document.createElement('img')
    img.style.width = '100%'
    img.style.height = '100%'
    img.src = src
    return img

perfectToDecimal = (per)->
    return parseFloat(per.substring(0, per.length - 1)) / 100.0

percentMinus = (per, delta)->
    p = parseFloat(per.substring(0, per.length - 1))
    return (p - delta) + '%'

class Effect
    constructor: (options)->
        @parent = options.elem
        @parent.style.position = 'relative'
        @parent.style.overflow = 'hidden'

        img = _createImg(options.src)
        @current = img
        @parent.appendChild(img)

    pushLeft: (imgURL)->
        newImg = _createImg(imgURL)
        newImg.style.position = 'absolute'
        @parent.appendChild(newImg)

        @current.style.marginLeft = '0%'

        finish = =>
            @parent.removeChild(@current)
            newImg.style.position = ""
            @current = newImg

        func = =>
            if perfectToDecimal(@current.style.marginLeft) <= -1
                finish()
                return
            @current.style.marginLeft = percentMinus(@current.style.marginLeft, 3)
            requestAnimationFrame(func)

        setTimeout ->
            requestAnimationFrame(func)
        , 1000


window.Effect = Effect
