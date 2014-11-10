( ($)->

	$.fn.srender = (data, directives)->

		# You can pass in your own custom directives for each srender call
		directives = $.extend({}, $.fn.srender.directives, directives)

		return @each ->

			console.log 'loop', @

			# Go over each attribute and get attributes
			for attribute in @attributes
				name = attribute.nodeName
				value = attribute.nodeValue

				# Only process attributes that are prefixed with **s-**
				if not /^s-/.test(name)
					continue

				# If there is a directive defined as a function
				if typeof directives[name] is 'function'
					directives[name].call(@, data, value)
					continue

				# If there is a match in the context, set the data to that
				_name = name.replace(/^s-/, '')
				if typeof data[_name] isnt 'undefined'
					if data[_name] is null
						$(@).html ''
					else
						$(@).text data[_name]

			# Process each of it's children
			child = $(':first-child', @)
			while child.length
				child.srender(data, directives)
				child = child.next()


	$.fn.srender.directives =
		's-attr-id': (context, value)->
			if typeof value isnt 'string'
				return

			value = value.replace /({{[^}}]+}})/g, (tempvar)->
				tempvar = tempvar.replace('{{', '').replace('}}', '')
				if typeof context[tempvar] isnt 'undefined'
					if context[tempvar] is null
						return ''
					else
						return context[tempvar]
				else
					return ''

			$(@).attr('id', value)

)(jQuery)