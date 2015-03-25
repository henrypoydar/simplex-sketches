
$(document).ready ->

  width = 1300
  height = 800
  edge_size = 200
  num_points = 300
  noise_spread = 600
  width_spread = 130
  height_spread = 80

  points = []
  noise_points = []
  center_points = []

  getClosestNum = (num, ar) ->
    i = 0
    closest = undefined
    closestDiff = undefined
    currentDiff = undefined
    if ar.length
      closest = ar[0]
      i
      while i < ar.length
        closestDiff = Math.abs(num - closest)
        currentDiff = Math.abs(num - ar[i])
        if currentDiff < closestDiff
          closest = ar[i]
        closestDiff = null
        currentDiff = null
        i++
      #returns first element that is closest to number
      return closest
    #no length
    false

  svg = d3.select('#svg-area')

  console.time("generate");

  # Colors
  blue_colors = []
  blue_colors_brightness = []
  spot_colors = []
  _.map liquitex_colors, (c) ->
    if c.name.match /blue/i
      blue_colors.push tinycolor(c.hex)
      blue_colors_brightness.push Math.floor(tinycolor(c.hex).getBrightness())
      lighten_factor = 15
      blue_colors.push tinycolor(c.hex).lighten(lighten_factor)
      blue_colors_brightness.push Math.floor(tinycolor(c.hex).lighten(lighten_factor).getBrightness())
    else
      spot_colors.push tinycolor(c.hex)

  # Generate underlying simplex noise map
  noise.seed Math.random()
  _(width + (edge_size*2)).times (x) ->
    noise_points[x] = []
    _(height + (edge_size*2)).times (y) ->
      val = noise.simplex2(x/noise_spread, y/noise_spread)
      noise_points[x].push val

  # Generate random points
  _(num_points).times ->
    points.push [Math.floor(Math.random()*(width+(edge_size*2)))-edge_size, Math.floor(Math.random()*(height+(edge_size*2)))-edge_size]

  # Generate linear points
  _(height/height_spread + 1).times (y) ->
    _(width/width_spread + 1).times (x) ->
      points.push [x*width_spread, y*height_spread]

  # Generate the polygons
  polygons = Delaunay.triangulate(points)

  # Draw the polygons
  i = polygons.length
  c = 0
  hue = Math.random()*360
  while i
    --i
    pt1x = points[polygons[i]][0]
    pt1y = points[polygons[i]][1]
    --i
    pt2x = points[polygons[i]][0]
    pt2y = points[polygons[i]][1]
    --i
    pt3x = points[polygons[i]][0]
    pt3y = points[polygons[i]][1]
    pts = "#{pt1x},#{pt1y} #{pt2x},#{pt2y} #{pt3x},#{pt3y}"
    ctpx = Math.floor((pt1x + pt2x + pt3x) / 3)
    ctpy = Math.floor((pt1y + pt2y + pt3y) / 3)
    center_points.push {x: ctpx, y: ctpy}

    # clr = "hsl(#{hue},33%,#{Math.floor(Math.abs(noise_points[ctpx+edge_size][ctpy+edge_size])*30)+50}%)"
    cval = Math.floor(Math.abs(noise_points[ctpx+edge_size][ctpy+edge_size])*128)+64
    # clr = color_matcher({r: cval, g: cval, b: cval})
    clr = _.shuffle(liquitex_colors)[0].hex
    clr = _.shuffle(blue_colors)[0].toHexString()

    # console.log getClosestNum(cval, blue_colors_brightness)
    # console.log blue_colors_brightness
    clr = blue_colors[_.indexOf(blue_colors_brightness, getClosestNum(cval, blue_colors_brightness))].toHexString()
    if Math.floor(Math.random()*20) == 0
      clr = _.shuffle(spot_colors)[0].toHexString()
    svg.append("polygon").
      attr("fill", clr).
      attr("stroke", clr).
      attr("stroke-width", 0.25).
      attr("points", pts)

  # Utility: plot polygon center points
  # _.map center_points, (p) ->
  #   svg.append("circle").
  #     attr("cx", p.x).
  #     attr("cy", p.y).
  #     attr("r", 2).
  #     attr("fill", "#fff")

  # Utility: plot polygon points
  # _.map points, (p) ->
  #   svg.append("circle").
  #     attr("cx", p[0]).
  #     attr("cy", p[1]).
  #     attr("r", 3).
  #     attr("fill")

  console.timeEnd("generate");

  # For exporting
  # svgd = document.getElementById('svg-area')
  # xml = new XMLSerializer().serializeToString(svgd)
  # data = "data:image/svg+xml;base64," + btoa(xml)
  # img  = new Image()
  # img.setAttribute('src', data)
  # document.body.appendChild(img)