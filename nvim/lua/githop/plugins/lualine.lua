local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine nightfly theme

lualine.setup()
