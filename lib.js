// Generated by CoffeeScript 1.7.1
(function() {
  var Effect, percentAdd, perfectToDecimal, _createImg;

  _createImg = function(src, style, cb) {
    var img, k;
    img = document.createElement('img');
    img.style.width = '100%';
    img.style.height = '100%';
    img.style.position = 'absolute';
    img.src = src;
    for (k in style) {
      img.style[k] = style[k];
    }
    return img.onload = function() {
      return cb(img);
    };
  };

  perfectToDecimal = function(per) {
    return parseFloat(per.substring(0, per.length - 1)) / 100.0;
  };

  percentAdd = function(per, delta) {
    var p;
    p = parseFloat(per.substring(0, per.length - 1));
    return (p + delta) + '%';
  };

  Effect = (function() {
    function Effect(options) {
      this.parent = options.elem;
      this.parent.style.position = 'relative';
      this.parent.style.overflow = 'hidden';
      _createImg(options.src, {
        position: 'absolute',
        left: '0%',
        top: '0%'
      }, (function(_this) {
        return function(img) {
          _this.current = img;
          return _this.parent.appendChild(img);
        };
      })(this));
    }

    Effect.prototype.pushLeft = function(imgURL) {
      return _createImg(imgURL, {
        left: '100%',
        top: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          delta = 1;
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          func = function() {
            if (perfectToDecimal(_this.current.style.left) <= -1) {
              finish();
              return;
            }
            _this.current.style.left = percentAdd(_this.current.style.left, -delta);
            newImg.style.left = percentAdd(newImg.style.left, -delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.pushRight = function(imgURL) {
      return _createImg(imgURL, {
        left: '-100%',
        top: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(_this.current.style.left) >= 1) {
              finish();
              return;
            }
            _this.current.style.left = percentAdd(_this.current.style.left, delta);
            newImg.style.left = percentAdd(newImg.style.left, delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.pushDown = function(imgURL) {
      return _createImg(imgURL, {
        top: '-100%',
        left: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(_this.current.style.top) >= 1) {
              finish();
              return;
            }
            _this.current.style.top = percentAdd(_this.current.style.top, delta);
            newImg.style.top = percentAdd(newImg.style.top, delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.pushUp = function(imgURL) {
      return _createImg(imgURL, {
        top: '100%',
        left: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(_this.current.style.top) <= -1) {
              finish();
              return;
            }
            _this.current.style.top = percentAdd(_this.current.style.top, -delta);
            newImg.style.top = percentAdd(newImg.style.top, -delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.slideUp = function(imgURL) {
      return _createImg(imgURL, {
        top: '100%',
        left: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(newImg.style.top) <= 0) {
              finish();
              return;
            }
            newImg.style.top = percentAdd(newImg.style.top, -delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.slideDown = function(imgURL) {
      return _createImg(imgURL, {
        top: '-100%',
        left: '0%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(newImg.style.top) >= 0) {
              finish();
              return;
            }
            newImg.style.top = percentAdd(newImg.style.top, delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    Effect.prototype.slideLeft = function(imgURL) {
      return _createImg(imgURL, {
        top: '0%',
        left: '100%'
      }, (function(_this) {
        return function(newImg) {
          var delta, finish, func;
          _this.parent.appendChild(newImg);
          finish = function() {
            _this.parent.removeChild(_this.current);
            return _this.current = newImg;
          };
          delta = 1;
          func = function() {
            if (perfectToDecimal(newImg.style.left) <= 0) {
              finish();
              return;
            }
            newImg.style.left = percentAdd(newImg.style.left, -delta);
            return requestAnimationFrame(func);
          };
          return requestAnimationFrame(func);
        };
      })(this));
    };

    return Effect;

  })();

  window.Effect = Effect;

}).call(this);

//# sourceMappingURL=lib.map
