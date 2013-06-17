# Singleton class for type coercion inside RubyJS.
#
# to_int(obj) converts obj to R.Fixnum
#
# to_int_native(obj) converts obj to a JS number primitive through R(obj).to_int() if not already one.
#
# There is a shortcut for Coerce.prototype: RCoerce.
#
#     RCoerce.to_num_native(1)
#
# @private
_coerce =

  native: (obj) ->
    if typeof obj != 'object'
      obj
    else
      obj.valueOf()


  str: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid string") unless typeof obj is 'string'
    _err.throw_type() unless typeof obj is 'string'
    obj


  num: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid num") unless typeof obj is 'number'
    _err.throw_type() unless typeof obj is 'number'
    obj


  int: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid int") unless typeof obj is 'number'
    _err.throw_type() unless typeof obj is 'number'
    Math.floor(obj)


  isArray: nativeArray.isArray or (obj) ->
    nativeToString.call(obj) is '[object Array]'


  is_arr: (obj) ->
    typeof obj is 'object' && obj != null && _coerce.isArray(obj.valueOf())


  is_str: (obj) ->
    return true if typeof obj is 'string'
    typeof obj is 'object' && obj != null && typeof obj.valueOf() is 'string'


  arr: (obj) ->
    _err.throw_type() if obj == null
    _err.throw_type() if typeof obj != 'object'
    obj = obj.valueOf()
    _err.throw_type() unless _coerce.isArray(obj)
    obj


  split_args: (args, offset) ->
    arg_len = args.length

    ary = []
    idx = offset
    while idx < arg_len
      el = args[idx]
      ary.push(el) unless el is undefined
      idx += 1

    ary


  call_with: (func, thisArg, args) ->
    a = args
    switch args.length
      when 0 then func(thisArg)
      when 1 then func(thisArg, a[0])
      when 2 then func(thisArg, a[0], a[1])
      when 3 then func(thisArg, a[0], a[1], a[2])
      when 4 then func(thisArg, a[0], a[1], a[2], a[3])
      when 5 then func(thisArg, a[0], a[1], a[2], a[3], a[4])
      when 6 then func(thisArg, a[0], a[1], a[2], a[3], a[4], a[5])
      # Slow fallback when passed more than 6 arguments.
      else func.apply(null, [thisArg].concat(nativeSlice.call(args, 0)))


R.Support.coerce = _coerce
__str = _coerce.str
__int = _coerce.int
__num = _coerce.num
__arr = _coerce.arr
__isArr = _coerce.is_arr
__isStr = _coerce.is_str
__call = _coerce.call_with