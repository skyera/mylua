-- http://lua-users.org/wiki/ObjectOrientationTutorial
-- : syntax sugar
--      call function
--      insert table as self
local MyClass = {}
MyClass.__index = MyClass
print("MyClass ", MyClass)

function MyClass.new(value)
    local obj = setmetatable({}, MyClass)
    obj.value = value
    return obj
end

function MyClass.set_value(self, newval)
    print("MyClass.set_value ", MyClass)
    self.value = newval
end

function MyClass.get_value(self)
    print("MyClass.get_value ", MyClass)
    return self.value
end

local obj = MyClass.new(3)
print("obj ", obj)
print(obj:get_value())
obj:set_value(4)
print(obj:get_value())

--
print("2nd version of class")
local MyClass = {}
MyClass.__index = MyClass

setmetatable(MyClass, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function MyClass.new(value)
    local obj = setmetatable({}, MyClass)
    obj.value = value
    return obj
end

function MyClass:set_value(newval)
    self.value = newval
end

function MyClass:get_value()
    return self.value
end

local obj = MyClass(3)
print(obj:get_value())
obj:set_value(1)
print(obj:get_value())

-- Inheritance
print("Inheritance")
local BaseClass = {}
BaseClass.__index = BaseClass

setmetatable(BaseClass, {
    __call = function(cls, ...)
        local obj = setmetatable({}, cls)
        obj:_init(...)
        return obj
    end,
})

function BaseClass:_init(value)
    print(debug.traceback("BaseClass::_init"))
    self.value = value
end

function BaseClass:set_value(newval)
    self.value = newval
end

function BaseClass:get_value()
    return self.value
end

local DerivedClass = {}
DerivedClass.__index = DerivedClass

setmetatable(DerivedClass, {
    __index = BaseClass, -- inheritance
    __call = function(cls, ...)
        local obj = setmetatable({}, cls)
        obj:_init(...)
        return obj
    end,
})

function DerivedClass:_init(val1, val2)
    BaseClass._init(self, val1)
    self.value2 = val2
end

function DerivedClass:get_value()
    return self.value + self.value2
end

local obj = DerivedClass(1, 2)
print(obj:get_value())
obj:set_value(3)
print(obj:get_value())

-------------------------------------------
--- Class
print('\nDog class')
Dog = {}
Dog.__index = Dog

function Dog:new()
    print(debug.traceback('Dog:new()'))
    obj = {sound='woof'}
    return setmetatable(obj, self)
end

function Dog:makeSound()
    print('I say '..self.sound)
end
-------------------------------------------
-- create object
mrDog = Dog:new()
mrDog:makeSound()

-- 
LoudDog = Dog:new()
LoudDog.__index = LoudDog

function LoudDog:new()
    obj = {}
    return setmetatable(obj, self)
end

function LoudDog:makeSound()
    s = self.sound .. ' '
    print(s .. s .. s)
end

seymour = LoudDog:new()
seymour:makeSound()

-- Rectangle
Rectangle = {area=0, length=0, width=0}
Rectangle.__index = Rectangle

function Rectangle:new(o, length, width)
    o = o or {}
    setmetatable(o, self)
    o.length = length or 0
    o.width = width or 0
    o.area = o.length * o.width
    return o
end

function Rectangle:printArea()
    print("Area:", self.area)
end

function Rectangle:__tostring()
    return string.format("length: %d, width: %d, area: %d", self.length, self.width, self.area)
end

r1 = Rectangle:new(nil, 10, 20)
r1:printArea()

r2 = Rectangle:new(nil, 3, 4)
r2:printArea()
r1:printArea()
print(r1)
print(r2)

