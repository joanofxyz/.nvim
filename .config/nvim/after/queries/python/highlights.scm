;; extends
((call
	(attribute
		[
			(attribute (identifier) @logger (#eq? @logger "logger"))
			(identifier) @logger (#eq? @logger "logger")
		] (identifier) @logtype (#any-of? @logtype "debug" "info" "warn" "error" "critical")
	)
) @logcall)
