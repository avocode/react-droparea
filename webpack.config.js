var path = require('path');
var webpack = require('webpack');

module.exports = {
    entry: [
        'webpack-dev-server/client?http://localhost:8080',
        'webpack/hot/dev-server',
        './demo/index.coffee'
    ],
    devtool: 'eval-source-map',
    debug: true,
    output: {
        path: './demo',
        publicPath: '/demo/',
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.coffee$/,
                loader: 'coffee'
            },
            {
                test: /\.less$/,
                loaders: ['style', 'css', 'less']
            },
            {
                test: /\.(png|jpg)$/,
                loader: 'url-loader?limit=8192'
            }
        ],
        noParse: /\.min\.js/
    },
    resolve: {
        extensions: ['', '.coffee', '.js']
    },
    resolveLoader: {
        modulesDirectories: ['node_modules']
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin()
    ]
}
