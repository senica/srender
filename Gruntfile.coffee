module.exports = (grunt)->
	
	grunt.initConfig
		########################################################################
		# https://github.com/gruntjs/grunt-contrib-coffee
		########################################################################
		coffee:
			build:
				files: [
					'srender.js': 'src/srender.coffee'
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
						'srender.js'
					]

	############################################################################
	# Load tasks
	############################################################################
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-injector'

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
			'coffee',
			'injector'
			'cheers'
		]