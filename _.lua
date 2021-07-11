local _ = (function()
  local result = {
    filter = function(predicate)
        return function(arr)
            local result = {}
            for k, v in pairs(arr) do
                if predicate(v) then
                    result[#result + 1] = v
                end
            end
            return result
        end
    end,
    map = function(projection)
        return function(arr)
            local result = {}
            for k, v in pairs(arr) do
                result[#result + 1] = projection(v)
            end
            return result
        end
    end,
    tap = function(callback)
        return function(arr)
            for k, v in pairs(arr) do
                callback(v)
            end
            return arr
        end
    end,
    flatMap = function(projection)
        return function(arr)
            local result = {}
            for k, v1 in pairs(arr) do
                for k, v2 in pairs(v1) do
                    result[#result + 1] = projection(v2)
                end
            end
            return result
        end
    end
  }
  result.pipe = function(wrapper)
      wrapper = wrapper or (function(a)
              return a
          end)
      return {
          pipe = function(inner)
              return result.pipe(
                  function(arr)
                      return inner(wrapper(arr))
                  end
              )
          end,
          run = function(o)
              return wrapper(o)
          end
      }
  end
  return result
end)()
