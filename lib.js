// Generated by CoffeeScript 1.7.1
(function() {
  var Effect, percentMinus, perfectToDecimal, _createImg;

  _createImg = function(src) {
    var img;
    img = document.createElement('img');
    img.style.width = '100%';
    img.style.height = '100%';
    img.src = src;
    return img;
  };

  perfectToDecimal = function(per) {
    return parseFloat(per.substring(0, per.length - 1)) / 100.0;
  };

  percentMinus = function(per, delta) {
    var p;
    p = parseFloat(per.substring(0, per.length - 1));
    return (p - delta) + '%';
  };

  Effect = (function() {
    function Effect(options) {
      var img;
      this.parent = options.elem;
      this.parent.style.position = 'relative';
      this.parent.style.overflow = 'hidden';
      img = _createImg(options.src);
      this.current = img;
      this.parent.appendChild(img);
    }

    Effect.prototype.pushLeft = function(imgURL) {
      var finish, func, newImg;
      newImg = _createImg(imgURL);
      newImg.style.position = 'absolute';
      this.parent.appendChild(newImg);
      this.current.style.marginLeft = '0%';
      finish = (function(_this) {
        return function() {
          _this.parent.removeChild(_this.current);
          newImg.style.position = "";
          return _this.current = newImg;
        };
      })(this);
      func = (function(_this) {
        return function() {
          if (perfectToDecimal(_this.current.style.marginLeft) <= -1) {
            finish();
            return;
          }
          _this.current.style.marginLeft = percentMinus(_this.current.style.marginLeft, 3);
          return requestAnimationFrame(func);
        };
      })(this);
      return setTimeout(function() {
        return requestAnimationFrame(func);
      }, 1000);
    };

    return Effect;

  })();

  window.Effect = Effect;

}).call(this);

//# sourceMappingURL=lib.map
