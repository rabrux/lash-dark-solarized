gulp    = require 'gulp'
sass    = require 'gulp-sass'
pug     = require 'gulp-pug'
concat  = require 'gulp-concat'
watch   = require 'gulp-watch'
connect = require 'gulp-connect'
prefix  = require 'gulp-autoprefixer'

# sources
styles = [
  # app
  'src/styles/*.sass'
  'src/styles/**/*.sass'
]

fonts = [
  # ionicons
  'bower_components/ionicons/fonts/*.*'
  # app
  'src/fonts/**/*.*'
]

docs = [
  'src/docs/*.pug'
  'src/docs/**/*.pug'
]

gulp.task 'styles', ->

  gulp
    .src "src/styles/config/#{ process.env.PALETTE }/index.sass"
    .pipe sass().on( 'error', sass.logError )
    .pipe prefix(
      browsers : [ 'last 5 versions' ]
      cascade : false
    )
    .pipe concat 'solarized.min.css'
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
    .src 'src/fonts/**/*.*'
    .pipe gulp.dest 'dist/fonts'

  return

gulp.task 'ionicons', ->
  gulp
    .src 'bower_components/ionicons/fonts/*.*'
    .pipe gulp.dest 'dist/fonts/ionicons'

  return

gulp.task 'fonts', [
  'system-fonts'
  'ionicons'
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
  gulp.watch [ 'dist/css/app-gui.min.css', 'docs/*.html', 'docs/**/*.html' ], [ 'reload' ]

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

