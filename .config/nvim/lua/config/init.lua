require("config.options")
require("config.plugins")

local mappings = require("config.mappings")
mappings.set_from_table(mappings.common)
