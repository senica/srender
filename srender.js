(function() {
  (function($) {
    $.fn.srender = function(data, directives) {
      directives = $.extend({}, $.fn.srender.directives, directives);
      return this.each(function() {
        var attribute, child, name, value, _i, _len, _name, _ref, _results;
        console.log('loop', this);
        _ref = this.attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attribute = _ref[_i];
          name = attribute.nodeName;
          value = attribute.nodeValue;
          if (!/^s-/.test(name)) {
            continue;
          }
          if (typeof directives[name] === 'function') {
            directives[name].call(this, data, value);
            continue;
          }
          _name = name.replace(/^s-/, '');
          if (typeof data[_name] !== 'undefined') {
            if (data[_name] === null) {
              $(this).html('');
            } else {
              $(this).text(data[_name]);
            }
          }
        }
        child = $(':first-child', this);
        _results = [];
        while (child.length) {
          child.srender(data, directives);
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
        return $(this).attr('id', value);
      }
    };
  })(jQuery);

}).call(this);
