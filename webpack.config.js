const path = require('path');
const rootPath = __dirname;

module.exports = {
  entry: './demo/index.js',
  output: {
    path: path.join(rootPath, 'demo'),
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      },

      {
        test: /\.js$/,
        loader: 'babel-loader'
      },

      {
        test: /\.less$/,
        loader: 'style!css!less'
      },

      {
        test: /\.css$/,
        loader: 'style!css'
      }

    ]
  },

  resolve: {
    alias: {
      stylesheets: path.join(rootPath, 'lib', 'assets', 'stylesheets'),
      javascripts: path.join(rootPath, 'lib', 'assets', 'javascripts'),
      vendor: path.join(rootPath, 'vendor')
    }
  }
};