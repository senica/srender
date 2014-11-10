module.exports = (grunt)->
	
	grunt.initConfig
		########################################################################
		# https://github.com/gruntjs/grunt-contrib-coffee
		########################################################################
		coffee:
			build:
				files: [
					'srender.js': 'src/srender.coffee'
					'tests/data.js': 'tests/data.coffee'
					'tests/tests.js': 'tests/tests.coffee'
				]

		########################################################################
		# https://github.com/klei/grunt-injector
		########################################################################
		injector:
			options:
				template: 'src/index.html'
			build:
				files:
					'index.html': [
						'src/jquery-2.1.1.js'
						'src/qunit.js'
						'src/qunit.css'
						'srender.js'
						'tests/data.js'
						'tests/tests.js'
					]

		########################################################################
		# https://github.com/gruntjs/grunt-contrib-connect
		########################################################################
		connect:
			server:
				options:
					port: 3000
					base: '.'

		########################################################################
		# https://github.com/gruntjs/grunt-contrib-qunit
		########################################################################
		qunit:
			build:
				options:
					urls: [
						'http://localhost:3000/index.html'
					]
					

	############################################################################
	# Load tasks
	############################################################################
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-injector'
	grunt.loadNpmTasks 'grunt-contrib-qunit'
	grunt.loadNpmTasks 'grunt-contrib-connect'

	############################################################################
	# Silly...but oh, so necessary
	############################################################################
	grunt.registerTask 'cheers',
		'Cheers', ->
			console.log('🍺  Cheers!')

	############################################################################
	# Start
	# run `grunt` to run this section
	############################################################################
	grunt.registerTask 'default', 'Default', ->
		console.log 'Building srender...'
		grunt.task.run [
			'coffee'
			'injector'
			'connect'
			'qunit'
		]