gulp    = require 'gulp'
sass    = require 'gulp-sass'
cssMin  = require 'gulp-clean-css'
pug     = require 'gulp-pug'
concat  = require 'gulp-concat'
watch   = require 'gulp-watch'
connect = require 'gulp-connect'
prefix  = require 'gulp-autoprefixer'

# environment variables
prod = process.env.PROD || false

# sources
styles = [
  # app
  'src/styles/*.sass'
  'src/styles/**/*.sass'
]

fonts = [
  # app
  'src/styles/fonts/**/*.eot'
  'src/styles/fonts/**/*.woff2'
  'src/styles/fonts/**/*.woff'
  'src/styles/fonts/**/*.ttf'
  'src/styles/fonts/**/*.svg'
]

docs = [
  'src/docs/*.pug'
  'src/docs/**/*.pug'
]

gulp.task 'styles', ->

  gulp
    .src "src/styles/palettes/#{ process.env.PALETTE }/index.sass"
    .pipe sass().on( 'error', sass.logError )
    .pipe prefix(
      browsers : [ 'last 5 versions' ]
      cascade : false
    )
    .pipe cssMin()
    .pipe concat "#{ process.env.PALETTE }.min.css"
    .pipe gulp.dest 'dist/css'

gulp.task 'docs', ->

  gulp
    .src docs
    .pipe pug().on 'error', ( err ) ->
      console.log err
    .pipe gulp.dest 'docs'

# copy custom fonts
gulp.task 'system-fonts', ->
  gulp
    .src fonts
    .pipe gulp.dest 'dist/fonts'

  return

gulp.task 'fonts', [
  'system-fonts'
]

gulp.task 'serve', ->
  connect.server
    root : '.'
    port : 8080
    livereload : true
  return

gulp.task 'reload', ->
  gulp
    .src [ 'docs', 'dist' ]
    .pipe connect.reload()
  return

gulp.task 'watch', ->
  gulp.watch styles, [ 'styles' ]
  gulp.watch fonts, [ 'fonts' ]
  gulp.watch docs, [ 'docs' ]
  gulp.watch [ "dist/css/#{ process.env.PALETTE }.min.css", 'docs/*.html' ], [ 'reload' ]

gulp.task 'compile', [
  'styles'
  'fonts'
  'docs'
]

gulp.task 'dev', [
  'compile'
  'serve'
  'watch'
]

gulp.task 'default', [
  'compile'
]

