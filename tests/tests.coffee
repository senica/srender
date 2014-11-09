
module 'JS Files'
test 'jQuery', (assert)->
	assert.equal(typeof jQuery, 'function')
test 'srender', (assert)->
	assert.equal(typeof srender, 'function')