
$(document).ready ->

  width = 1300
  height = 800
  edge_size = 200
  num_points = 300
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
      val = noise.simplex2(x/500, y/500)
      noise_points[x].push val

  # Generate random points
  _(num_points).times ->
    points.push [Math.floor(Math.random()*(width+(edge_size*2)))-edge_size, Math.floor(Math.random()*(height+(edge_size*2)))-edge_size]

  # Generate linear points
  _(9).times (y) ->
    _(14).times (x) ->
      points.push [x*100, y*100]

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
    clr = "hsl(0,0%,#{Math.abs(noise_points[ctpx+edge_size][ctpy+edge_size])*100}%)"

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