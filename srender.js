(function() {
  (function($) {
    $.fn.srender = function(data, directives) {
      directives = $.extend({}, $.fn.srender.directives, directives);
      return this.each(function() {
        var attribute, child, context, name, r, value, _i, _len, _name, _ref, _results;
        context = data;
        if (typeof this._s === 'undefined') {
          this._s = {};
        }
        _ref = this.attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attribute = _ref[_i];
          name = attribute.nodeName;
          value = attribute.nodeValue;
          if (!/^s-/.test(name)) {
            continue;
          }
          if (typeof directives[name] === 'function') {
            r = directives[name].call(this, context, value);
            if (Array.isArray(r) || typeof r === 'object' && r !== null) {
              context = r;
            }
            continue;
          }
          _name = name.replace(/^s-/, '');
          if (typeof context[_name] !== 'undefined') {
            if (context[_name] === null) {
              $(this).html('');
            } else {
              $(this).text(context[_name]);
            }
          }
        }
        child = $('> :first-child', this);
        _results = [];
        while (child.length) {
          child.srender(context, directives);
          _results.push(child = child.next());
        }
        return _results;
      });
    };
    return $.fn.srender.directives = {
      's-attr-id': function(context, value) {
        if (typeof value !== 'string') {
          return;
        }
        value = value.replace(/({{[^}}]+}})/g, function(tempvar) {
          tempvar = tempvar.replace('{{', '').replace('}}', '');
          if (typeof context[tempvar] !== 'undefined') {
            if (context[tempvar] === null) {
              return '';
            } else {
              return context[tempvar];
            }
          } else {
            return '';
          }
        });
        $(this).attr('id', value);
      },
      's-repeat': (function() {
        var style;
        style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = '.s-repeat-hidden { display:none; }';
        $('head')[0].appendChild(style);
        return function(context, value) {
          var first, length, name, parent, siblings, _value;
          name = value.replace(/({{[^}}]+}})/g, function(tempvar) {
            return tempvar.replace('{{', '').replace('}}', '');
          });
          _value = context[name];
          if (!Array.isArray(_value)) {
            return;
          }
          parent = $(this).parent();
          siblings = parent.find('[s-repeat="' + value + '"]');
          first = siblings.first()[0];
          length = Math.max(_value.length, 1);
          if (first === this) {
            $(first).removeClass('s-repeat-hidden');
            while (siblings.length > length) {
              siblings.last().remove();
              siblings = parent.find('[s-repeat="' + value + '"]');
            }
          }
          if (!_value.length) {
            $(first).addClass('s-repeat-hidden');
          }
          if (siblings.length < length) {
            siblings.first().clone().insertAfter(siblings.last());
          }
          return _value[siblings.index(this)];
        };
      })()
    };
  })(jQuery);

}).call(this);
