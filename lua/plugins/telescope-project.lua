return {
	'nvim-telescope/telescope-project.nvim',
	dependencies = { 'nvim-telescope/telescope.nvim' },
	config = function()
		require('telescope').setup({
    			extensions = {
				project = {
					base_dirs = {
						'C:/Users/Samue/Projetos',
					},
				},
			},
    		})
  	end,
}
