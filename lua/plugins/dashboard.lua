--
-- Dashboard
--
-- Fancy and Blazing Fast start screen plugin of neovim
--
-- https://github.com/nvimdev/dashboard-nvim
--
return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
        local lolcrab = vim.fn.executable("lolcrab") == 1
        local logo_path = vim.fn.stdpath("config") .. "/lua/assets/metrol.txt"

        require("dashboard").setup({
            theme = "doom",
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
                            vim.cmd("rshada") -- refresh oldfiles from disk
                            require("telescope.builtin").oldfiles({
                                only_cwd = true,
                                initial_mode = "normal"
                            })
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
                    {
                        icon = " ",
                        desc = "LazyGit",
                        key = "g",
                        action = function()
                            vim.cmd [[LazyGit]]
                        end,
                    },
                    {
                        icon = "󰒲 ",
                        desc = "Plugin Manager",
                        key = "l",
                        action = "Lazy",
                    },
                    {
                        -- icon = "󰒲 ",
                        icon = " ",
                        desc = "Mason",
                        key = "m",
                        action = "Mason",
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
