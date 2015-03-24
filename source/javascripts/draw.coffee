
$(document).ready ->

  width = 1300
  height = 800
  edge_size = 200
  num_points = 300
  noise_spread = 1000
  linear_spread = 100

  points = []
  noise_points = []
  center_points = []

  svg = d3.select('#svg-area')

  console.time("generate");

  # Colors
  colors = []
  hex_colors = []
  _.map liquitex_colors, (c) ->
    colors.push pusher.color(c.hex)
  colors = _.sortBy colors, (c) ->
    c.hue()
  _.map liquitex_colors, (c) ->
    hex_colors.push c.hex

  color_matcher = nearestColor.from(hex_colors)

  # Generate underlying simlpex noise map
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
  _(height/linear_spread + 1).times (y) ->
    _(width/linear_spread + 1).times (x) ->
      points.push [x*linear_spread, y*linear_spread]

  # Generate the polygons
  polygons = Delaunay.triangulate(points)


  # Draw the polygons
  i = polygons.length
  c = 0
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
    clr = "hsl(160,33%,#{Math.floor(Math.abs(noise_points[ctpx+edge_size][ctpy+edge_size])*30)+50}%)"
    # cval = Math.floor(Math.abs(noise_points[ctpx+edge_size][ctpy+edge_size])*256)
    # clr = color_matcher({r: cval, g: cval, b: cval})
    svg.append("polygon").
      attr("fill", clr).
      attr("stroke", clr).
      attr("stroke-width", 1).
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