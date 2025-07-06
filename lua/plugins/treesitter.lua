return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                auto_install = true,
                ensure_installed = {"php", "javascript"},
                sync_install = false,

                highlight = {
                    enable = true
                },

                indent = {
                    enable = true
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = {
                                query = "@function.outer",
                                desc  = "Around function"
                            },
                            ["if"] = {
                                query = "@function.inner",
                                desc  = "Inner part of function"
                            },
                            ["ii"] = {
                                query = "@conditional.inner",
                                desc = "Inner part of conditional"
                            },
                            ["ai"] = {
                                query = "@conditional.outer",
                                desc = "Around conditional"
                            },
                            ["il"] = {
                                query = "@loop.inner",
                                desc = "Inner part of loop"
                            },
                            ["al"] = {
                                query = "@loop.outer",
                                desc = "Around loop"
                            },
                            ["ia"] = {
                                query = "@parameter.inner",
                                desc = "Parameter/Argument"
                            },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'v', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    }
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects"
    }
}
