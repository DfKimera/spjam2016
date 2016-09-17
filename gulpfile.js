var gulp   = require('gulp'),
	concat = require('gulp-concat'),
	sourcemaps = require('gulp-sourcemaps');

gulp.task('default', ['watch']);

gulp.task('watch', function() {
	gulp.watch('src/**/*.js', ['build-js']);
});

gulp.task('build-js', function() {
	return gulp.src('src/**/*.js')
		.pipe(sourcemaps.init())
		.pipe(concat('bundle.js'))
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('dist'));
});