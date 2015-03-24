activate :livereload
activate :autoprefixer

activate :directory_indexes
activate :relative_assets
set      :relative_links, true
set      :css_dir,        "stylesheets"
set      :js_dir,         "javascripts"
set      :images_dir,     "images"

page "/*", layout: "application"

set :haml, attr_wrapper: '"'
configure :build do
  activate :minify_css
  activate :minify_javascript
end

