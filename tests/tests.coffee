
module 'JS Files'
test 'jQuery', (assert)->
	assert.equal(typeof jQuery, 'function')
test 'srender', (assert)->
	assert.equal(typeof $('<div>').srender, 'function')

module 'Render'
test 'Set IDs', (assert)->
	$('.srender-me').srender(data)
	assert.equal $('.srender-me').first().attr('id'), 1
	assert.equal $('.srender-me').last().find('div:first').attr('id'), 1