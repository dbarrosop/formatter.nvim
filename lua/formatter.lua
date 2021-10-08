local M = {
    defaults = {
        enable = false,
        formatter_func = "lua vim.lsp.buf.formatting_sync()"
    }
}

local function get(x, if_false)
    if x ~= nil then
        return x
    else
        return if_false
    end
end

local function addUserCommands()
    local function addUserCommand(alias, cmd)
        vim.cmd(string.format('command! %s %s', alias, cmd))

    end

    addUserCommand("Formatter", "lua require'formatter'.format()")
    addUserCommand("FormatterInfo", "lua require'formatter'.info()")

    vim.api.nvim_command(
        "command! -nargs=? FormatterEnable call luaeval(\"require'formatter'.enable(_A)\", expand('<args>'))")
    vim.api.nvim_command(
        "command! -nargs=? FormatterDisable call luaeval(\"require'formatter'.disable(_A)\", expand('<args>'))")

    addUserCommand("FormatterBufferEnable",
                   "lua require'formatter'.buf_enable()")
    addUserCommand("FormatterBufferDisable",
                   "lua require'formatter'.buf_disable()")
end

local function setDefaults(opts)
    if opts.defaults then
        M.defaults.enable = get(opts.defaults.enable, M.defaults.enable)
        M.defaults.formatter_func = get(opts.defaults.formatter_func,
                                        M.defaults.formatter_func)
    end
    opts.defaults = nil
end

local is_enabled = function()
    if vim.b.formatter_enable ~= nil then return vim.b.formatter_enable end
    local ftc = M[vim.api.nvim_buf_get_option(0, "filetype")]
    if ftc ~= nil then return ftc.enable end
    return M.defaults.enable
end

local function get_option(opt)
    local ft = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(),
                                           "filetype")
    if M[ft] ~= nil then return get(M[ft][opt], M.defaults[opt]) end
    return M.defaults[opt]
end

local function set_option(ft, opt, value)
    if ft == nil or ft == "" then
        M.defaults[opt] = value
        return
    end

    if M[ft] == nil then M[ft] = {} end
    M[ft][opt] = value
end

M.setup = function(opts)
    if vim.g.loaded_formatter then return end

    setDefaults(opts)

    for k, v in pairs(opts) do M[k] = v end

    addUserCommands()

    vim.g.loaded_formatter = true
end

--- Run the formatter in the uurrent buffer
M.format = function()
    if is_enabled() then vim.cmd(get_option("formatter_func")) end
end

--- Enable formatter for the current buffer
M.buf_disable = function() vim.b.formatter_enable = false end

--- Disable formatter for the current buffer
M.buf_enable = function() vim.b.formatter_enable = true end

--- Disable formatter
--- @param ft string|nil If not nil, disable for this filetype only
M.disable = function(ft) set_option(ft, "enable", false) end

--- Enable formatter
--- @param ft string|nil If not nil, enable for this filetype only
M.enable = function(ft) set_option(ft, "enable", true) end

--- Prints configuration
M.info = function()
    local function print_table(t, pre)
        for k, data in pairs(t) do
            if type(data) == "function" then
                goto continue
            elseif type(data) == "table" then
                print(pre .. k .. ":")
                print_table(data, pre .. "\t")
            else
                print(pre .. k .. ":", data)
            end
            ::continue::
        end
    end
    print("Configuration:\n")
    print_table(M, "\t")
    local b = vim.b.formatter_enable
    if b ~= nil then print("Current buffer enabled:", b) end

end

return M
