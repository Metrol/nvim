# nvim
My ever evolving Neovim configuration
# Goals
I'm primarily a [PHP](https://www.php.net) developer professionally.  My daily driver for development work is [PhpStorm](https://www.jetbrains.com/phpstorm/), and will likely stay that way for the foreseeable future.  It's proven to be worth every penny for the work that I do.

I'm using [Kubuntu](https://kubuntu.org/) on my desktop, with [Konsole](https://konsole.kde.org/) as my terminal.  I'm also rather fond of [Terminator](https://gnome-terminator.org/) as well.

I wanted to take a stab at configuring Neovim into doing as much of an [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment) role as it is able.  For me, that's working with PHP, JavaScript, HTML, Twig, CSS, JSON, XML, and a variety of other formats.  I've also started dabbling with [Go](https://go.dev/) as well.

At this time, I don't intend to put any serious Git tooling into Neovim.  I found I rather like having [Lazygit](https://github.com/jesseduffield/lazygit) running in a separate shell doing what it does really well.
# Credits
I've taken a stab at configuring NeoVIM in the past, but I've always run into some issue that prevented me from getting everything working.  At least the things I felt were important to get working.  Thankfully, some things have changed.

First off, a huge shout out to [typecraft](https://www.youtube.com/@typecraft_dev) over on YouTube.  His [Neovim for Newbs](https://www.youtube.com/playlist?list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn) playlist not only got the ball rolling for me, but provided a much better understanding of how to get things configured.  So much more useful than just downloading a set of configuration files and trying to muddle through.

Secondly, serious nod to how far [Neovim](https://neovim.io/) has progressed over the last few releases.  So much of what I've been able to get going, as little as it may be, I don't think would have been possible a year or two ago.

Neovim is fine and all, but what really puts things over the top are all the plugin developers who have collectively taken this editor into the next level.
## Dependencies
Before getting into the list, I want to point out a couple of dependencies that a Linux system will likely need in order to get things running.

[BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) is needed for the Telescope plugin.
[npm](https://www.npmjs.com/) will be needed for the JavaScript LSP and some of the plugins.
[Intelephense](https://intelephense.com/) I'm using for the PHP LSP.  I spent the $20 to get a license key.

The painful one of the bunch was putting `npm` on my system.  I've never seen a package with so many dependencies!  Anyhow, on an Ubuntu based system...
```bash
sudo apt install ripgrep npm
```

To get things looking right, [Nerd Fonts](https://www.nerdfonts.com/) are required.  I went to the [download page](https://www.nerdfonts.com/font-downloads) and fetched `JetBrainsMono Nerd Font`.  I didn't install all of those fonts in the package, just the regular ones.  Then, whatever terminal program your using needs to be using that font.  Any plugin that's calling out a dependency on `"nvim-tree/nvim-web-devicons"` will need a nerd font in place.
# Plugins
The order of these plugins tracks on the videos that [typecraft](https://www.youtube.com/playlist?list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn) presented in his video series.  I've since added a few to the mix, and will likely continue to do so, while tweaking things into place.

Likely, the most important plugin is the tool that manages all the other plugins.
[Lazy Plugin Manager](https://github.com/folke/lazy.nvim)

Quickly find files, and search within files.  This is where `ripgrep` is needed.
[Telescope](https://github.com/nvim-telescope/telescope.nvim)

Syntax highlights
[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

Tree style file browser
[Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)

Fancy, and informative, status bar
[Lualine](https://github.com/nvim-lualine/lualine.nvim)

LSP Related.  There are a bunch here that all interact with each other.
[Mason](https://github.com/williamboman/mason.nvim)
[Mason LSPConfig](https://github.com/williamboman/mason-lspconfig.nvim)
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
[Telescope-UI](https://github.com/nvim-telescope/telescope-ui-select.nvim)
[None-LS](https://github.com/nvimtools/none-ls.nvim)

File tabs, making dealing with multiple files easier to visualize
[barbar](https://github.com/romgrk/barbar.nvim)

Code Structure outline
[Outline](https://github.com/hedyhli/outline.nvim)

# Still To Do
I haven't worked debugging tools into the mix just yet.  Trying to get comfortable with all of these other tools first.

I still have some other visual adjustments I'd like to work into the mix.  I'll be playing with some of that before too long.

It's clear to me that this is a journey without a fixed destination.  So far, it's been pretty fun!
