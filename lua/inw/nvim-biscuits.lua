return {
    'code-biscuits/nvim-biscuits',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        -- Config goes here
    },
    config = function()
        require('nvim-biscuits').setup({
            show_on_start = false,
            cursor_line_only = true,
            toggle_keybind = "<leader>sb",
            default_config = {
                max_length = 12,
                min_distance = 5,
                prefix_string = " 📎 "
            },
            language_config = {
                html = {
                    prefix_string = " 🌐 "
                },
                twig = {
                    prefix_string = " 🌐 "
                },
                javascript = {
                    prefix_string = " ✨ ",
                    max_length = 80
                },
                php = {
                    prefix_string = " ✨ ",
                    max_length = 80
                },
                python = {
                    disabled = true
                }
            }
        })
    end
}

