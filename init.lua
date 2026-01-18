-- -- settings need to load first as it contains the leader key mapping, which has to happen before lazy
-- require("andyterrify.remap")
-- require("andyterrify.settings")
-- require("andyterrify.autocommands")
--
--
-- -- load lazy first of all
-- require("andyterrify.lazy_init")
--
-- settings need to load first as it contains the leader key mapping, which has to happen before lazy
--

-- local function get_hostname()
-- 	local handle = io.popen("hostname")
-- 	local hostname = handle:read("*a")
-- 	handle:close()
-- 	return string.match(hostname, "^%s*(.-)%s*$") -- trim whitespace
-- end
-- local machine_id = get_hostname()
-- print(machine_id)
-- vim.g.is_personal = machine_id == "zephyrus"


-- require("andyterrify.init")
require("avasile.init")

-- pcall(require, "work.init")

-- require("new.remap")
-- require("new.settings")
-- require("new.autocommands")

-- load lazy first of all
-- require("new.lazy_init")
