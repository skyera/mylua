local ffi = require("ffi")

ffi.cdef[[
int rand(void);
int atoi(const char*);
]]

for i = 0, 3 do
    local num = ffi.C.rand()
    print(num)
end

local num = ffi.C.atoi("12")
print(num)
