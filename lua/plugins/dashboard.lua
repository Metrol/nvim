return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
        local lolcrab = vim.fn.executable("lolcrab") == 1
        -- local logo_path = vim.fn.stdpath("config") .. "/lua/assets/dashboard.txt"
        local logo_path = vim.fn.stdpath("config") .. "/lua/assets/metrol.txt"

        require("dashboard").setup({
            theme = "doom",
            -- preview = lolcrab and {
            --     -- lolcrab has different gradients built in
            --     -- lolcrab -g cool for example
            --     -- you can check the presets out with lolcrab --presets
            --     command = "lolcrab -g warm",
            --     file_path = logo_path,
            --     file_width = 69,
            --     file_height = 8,
            -- },
            config = {
                header = (not lolcrab) and vim.fn.readfile(logo_path) or nil,
                center = {
                    {
                        icon = " ",
                        desc = "File Explorer",
                        key = "e",
                        action = function()
                            vim.cmd [[Neotree filesystem reveal left]]
                        end,
                    },
                    {
                        icon = " ",
                        desc = "Recent Files",
                        key = "r",
                        action = function()
                            vim.cmd [[Telescope recent_files initial_mode=insert]]
                        end,
                    },
                    {
                        icon = " ",
                        desc = "Find Files",
                        key = "f",
                        action = function()
                            require("telescope.builtin").find_files()
                        end,
                    },
                    {
                        icon = " ",
                        desc = "Projects",
                        key = "p",
                        action = function()
                            vim.cmd [[Telescope projects initial_mode=normal]]
                        end,
                    },
                    -- {
                    --     icon = " ",
                    --     desc = "Dotfiles",
                    --     key = "d",
                    --     action = function()
                    --         require("fzf-lua").files({ cwd = vim.fn.expand("~/.dotfiles") })
                    --     end,
                    -- },
                    {
                        -- icon = "󰒲 ",
                        icon = " ",
                        desc = "Mason",
                        key = "m",
                        action = "Mason",
                    },
                    {
                        icon = "󰒲 ",
                        desc = "Plugin Manager",
                        key = "l",
                        action = "Lazy",
                    },
                    {
                        icon = "󰿅 ",
                        desc = "Quit Neovim",
                        key = "q",
                        action = "qa",
                    },
                },
                footer = {},
            },
        })
    end,
}
