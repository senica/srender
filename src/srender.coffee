( ($)->

	$.fn.srender = (data, directives)->

		# You can pass in your own custom directives for each srender call
		directives = $.extend({}, $.fn.srender.directives, directives)

		return @each ->

			context = data

			# namespaced property that can be used in directives
			if typeof @_s is 'undefined'
				@_s = {}

			# Go over each attribute and get attributes
			for attribute in @attributes
				name = attribute.nodeName
				value = attribute.nodeValue

				# Only process attributes that are prefixed with **s-**
				if not /^s-/.test(name)
					continue

				# If there is a directive defined as a function
				# call that. If the return value is an array of object
				# set that as the context
				if typeof directives[name] is 'function'
					r = directives[name].call(@, context, value)
					if Array.isArray(r) or typeof r is 'object' and r isnt null
						context = r
					continue

				# If there is a match in the context, set the data to that
				_name = name.replace(/^s-/, '')
				if typeof context[_name] isnt 'undefined'
					if context[_name] is null
						$(@).html ''
					else
						$(@).text context[_name]

			# Process each of it's children
			child = $('> :first-child', @)
			while child.length
				child.srender(context, directives)
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
			return

		's-repeat': (->

			# Create a style to hide first element that is repeatable
			# if the array length is 0. We don't want to remove it because
			# we use it to clone when there is data
			style = document.createElement('style')
			style.type = 'text/css'
			style.innerHTML = '.s-repeat-hidden { display:none; }'
			$('head')[0].appendChild(style)

			return (context, value)->

				# Extract the actual value
				name = value.replace /({{[^}}]+}})/g, (tempvar)->
					tempvar.replace('{{', '').replace('}}', '')
				_value = context[name]
				if not Array.isArray(_value)
					return

				parent = $(@).parent()
				siblings = parent.find('[s-repeat="'+value+'"]')
				first = siblings.first()[0]
				length = Math.max _value.length, 1 # keep the first one always

				# If this is the first element in the repeat match, remove
				# extra siblings
				if first is @

					$(first).removeClass('s-repeat-hidden')

					# Remove extra siblings
					while siblings.length > length
						siblings.last().remove()
						siblings = parent.find('[s-repeat="'+value+'"]')

				if not _value.length
					$(first).addClass('s-repeat-hidden')

				# If there are more siblings to be made, make one, so the process
				# can continue. The main child/siblings loop will pick up the
				# newly created one and continue from there
				if siblings.length < length
					siblings.first().clone().insertAfter(siblings.last())
				
				# Process the rest of the attributes and children in a new context
				return _value[siblings.index(@)]
		)()


)(jQuery)