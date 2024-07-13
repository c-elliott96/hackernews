module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    fontFamily: {
      'sans': ['Verdana', 'Geneva', 'sans-serif']
    },
    fontSize: {
      base: ['10pt'],
      small: ['8pt'],
      xsmall: ['7pt']
    },
    extend: {
      colors: {
        'hackernews-light-gray': '#f6f6ef',
        'hackernews-story-gray': '#828282',
        'hackernews-orange': '#ff6600'
      },
    }
  }
}
