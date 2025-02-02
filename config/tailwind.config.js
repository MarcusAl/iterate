module.exports = {
  content: [
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
  ],
  plugins: [
    require("daisyui")
  ],
  daisyui: {
    themes: ["light"],
    darkTheme: "dark",
    base: true,
    styled: true,
    utils: true,
    prefix: "",
  },
}
