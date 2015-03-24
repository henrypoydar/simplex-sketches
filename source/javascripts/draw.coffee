
$(document).ready ->



  # TODO
  # - hover pallette
  # - hover grid

  # img = document.createElement("img")
  # img.src = "http://paperjs.org/tutorials/images/working-with-rasters/mona.jpg";
  # img.id = "mona"
  # # raster = new paper.Raster('mona')
  # document.body.appendChild(img);
  # canvas = document.getElementById('paper-canvas');
  # paper.setup(canvas)
  # raster = new paper.Raster('mona')
  # raster.scale(0.5)
  # raster.rotate(45)
  # # http://paperjs.org/tutorials/images/color-averaging-image-areas/

  width = 1300
  height = 800
  edge_size = 200
  num_points = 300
  points = []
  svg = d3.select('#svg-area')


  filter = svg.append("defs")
    .append("filter")
      .attr("id", "blur")
    .append("feGaussianBlur")
      .attr("stdDeviation", 2)

  # Colors
  colors = []



  # ...


  console.time("generate");

  _.map liquitex_colors, (c) ->
    colors.push pusher.color(c.hex)

  colors = _.sortBy colors, (c) ->
    c.hue()



  _.map colors, (c) ->
    console.log c.hue()

  # $.ajax
  #   url: 'data/colors.json'
  #   async: false
  #   dataType: 'json'
  #   success: (res) ->
  #     _.map res, (o) ->
  #       console.log o.munsell_hue
  #       if o.munsell_hue == 'PB'
  #         _.map o.children, (c) ->
  #           # if c.company == 'Liquitex' and _.contains(liquitex_hgp_alpha, c.name)
  #           if c.company == 'Liquitex'
  #             console.log c.name
  #             colors.push c.hex
  #             return
  #     return


  # Designer Set of 6 - Includes six 2 oz tubes consisting of Cadmium Yellow Medium Hue, Ivory Black, Phthalo Blue (Green Shade), Phthalo Green (Blue Shade), Quinacridone Crimson and Titanium White.

  #Classic Set of 8 - Includes eight 2 oz jars consisting of Dioxazine Purple, Ivory Black, Naphthol Crimson, Emerald Green, Cadmium Yellow Medium Hue, Titanium White, Phthalo Blue (Green Shade) and Cadmium Orange Hue.

  # Generate points
  _(num_points).times ->
    points.push [Math.floor(Math.random()*(width+(edge_size*2)))-edge_size, Math.floor(Math.random()*(height+(edge_size*2)))-edge_size]

  # Generate linear points
  _(18).times (y) ->
    _(28).times (x) ->
      points.push [x*100, y*100]



  polygons = Delaunay.triangulate(points)



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
    # clr = _.shuffle(liquitex_colors)[0].hex
    unless c < colors.length
      c = 0
    clr = colors[c].hex6()
    c++
    svg.append("polygon").
      # attr("fill", "hsl(190,100%,#{(Math.random()*10)+30}%)").
      attr("fill", clr).
      attr("stroke", clr).
      attr("stroke-width", 1).
      attr("points", pts)
      # attr("filter", "url(#blur)")

  # svg.append("text").
  #   attr('x', width/3*2).attr('y', height/3*2).
  #   attr('fill', '#FADEDE').
  #   style("font-family", "Helvetica Neue").
  #   style("font-size", height*2).
  #   style("font-weight", 100).
  #   style("text-anchor", "middle").
  #   text("@")

  console.timeEnd("generate");

  # Plot points
  # _.map points, (p) ->
  #   svg.append("circle").
  #     attr("cx", p[0]).
  #     attr("cy", p[1]).
  #     attr("r", 3).
  #     attr("fill")