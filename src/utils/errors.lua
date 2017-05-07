local errors = {}

errors.unknownAxisError = function(axis) error('Unknown axis: ' .. axis) end

return errors
