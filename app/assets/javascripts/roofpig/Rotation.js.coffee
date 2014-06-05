#= require roofpig/Side

class @Rotation
  constructor: (code) ->
    [@side, @turns] = Rotation._parse_code(code)

    @turn_time = 200 * (1 + Math.abs(@turns))

  @_parse_code: (code) ->
    turns = switch code.substring(1)
      when ">"   then 1
      when ">>"  then 2
      when "<"  then -1
      when "<<" then -2
    unless (side = Side.side_by_name(code[0])) && turns
      throw new Error("Invalid Rotation code '#{code}'")
    [side, turns]

  do: (world3d) ->
    this._do(world3d.camera, @turns, false)

  undo: (world3d) ->
    this._do(world3d.camera, -@turns, false)

  premix: (world3d) ->
    # No Rotations in premix

  show_do: (world3d) ->
    this._do(world3d.camera, @turns, true)

  show_undo: (world3d) ->
    this._do(world3d.camera, -@turns, true)

  _do: (camera, do_turns, animate) ->
    new CameraMovement(camera, @side.normal, do_turns * Math.PI/2, @turn_time, animate)

  count: -> 0

  to_s: ->
    turn_code = switch @turns
      when  1 then ">"
      when  2 then ">>"
      when -1 then "<"
      when -2 then "<<"

    "#{@side.name}#{turn_code}"

  standard_text: -> ''