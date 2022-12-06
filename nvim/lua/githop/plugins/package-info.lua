local setup, package_info = pcall(require, "package-info")
if not setup then
	return
end

package_info.setup()
