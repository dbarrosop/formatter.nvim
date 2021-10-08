# formatter.nvim

Neovim plugin to help you manage when and how to run code formatters

This plugin doesn't introduce mechanisms to define code formatters, instead, it leverages existing ones and let's you define when and how to run them. Some key features are:

1. Define different formatters for different filetypes.
2. Enable or disable running the formatter at the filetype level
3. Enable or disable running the formatter at the buffer level
4. Enable or disable running the formatter globally

![Demo](docs/demo.svg)

## Installation

Using vim-plug:

    Plug 'dbarrosop/formatter.nvim'

Using packer.nvim:

    use 'dbarrosop/formatter.nvim'

## Usage

You need to initialize the plugin using the function `formatter.setup()`. Once
it's been initialized you can run the * `Formatter` command to format your
code. If you prefer to run it automatically when you save a file you can add
an autocommand for it.
For instance:

    au BufWritePre * :Formatter<CR>

## Setup

You need to call the `formatter.setup()` function. For example:

    lua << EOF
    require"formatter".setup({
        defaults = {
            enabled = false,                                     -- by default don't format any file
            formatter_func = "lua vim.lsp.buf.formatting_sync()" -- Use lsp to format code
        },
        go = {
            enabled = true -- enable code formatting for go filetype using default formatter func
        },
        lua = {
            enabled = true,                 -- enable code formatting for lua filetype
            formatter_func = "LuaFormatter" -- use LuaFormatter command instead of lsp
        }
    })
    EOF

## Commands

* `:Formatter`

Runs the formatter. If the formatter is disabled this is a NOOP, otherwise,
run `formatter_func`.

* `FormatterInfo`

Prints on screen current configuration for the plugin

* `FormatterEnable`

Enables the formatter. If a filetype is specified in the command the
formatter is enabled for the given filetype, otherwise, it is enabled in
the `defaults` section.

* `FormatterDisable`

Disables the formatter. If a filetype is specified in the command the
formatter is disabled for the given filetype, otherwise, it is disabled in
the `defaults` section.

* `FormatterBufferEnable`

Enables the formatter for the current buffer.

* `FormatterBufferDisable`

Disables the formatter for the current buffer.

## Lua Module

```
formatter.setup({opts})
    Setup function to be run by user.

    Usage:

    require"formatter".setup({
        defaults = {
            enabled = false,                                     -- by default don't format any file
            formatter_func = "lua vim.lsp.buf.formatting_sync()" -- Use lsp to format code
        },
        go = {
            enabled = true -- enable code formatting for go filetype using default formatter func
        },
        lua = {
            enabled = true,                 -- enable code formatting for lua filetype
            formatter_func = "LuaFormatter" -- use LuaFormatter command instead of lsp
        }
    })

formatter.info()
    Prints current configuration

formatter.enable({ft})
    Enables the formatter for the default filetype or for a specific one.

    Parameters: ~
        {ft}    (string) Optionnal. If specified, enable the formatter for
                this filetype. Otherwise, enable the formatter for the
                default filetype

formatter.disable({ft})

    Disables the formatter for the default filetype or for a specific one.

    Parameters: ~
        {ft}    (string) Optionnal. If specified, disable the formatter for
                this filetype. Otherwise, disable the formatter for the
                default filetype

formatter.buf_enable()

    Enables the formatter for the current buffer.

formatter.buf_disable()

    Disables the formatter for the current buffer.

```
