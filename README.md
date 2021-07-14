> Disclaimer: This is a experimental package, but you are more than welcome to open issues and pull requests in order to request new features.

### Example

```elm
googleMapView : String -> Html Msg
googleMapView googleMapKey =
    Map.init googleMapKey
        |> Map.toHtml
```

> Please, take a look at examples/src/Main.elm

### How to install

With the `@PaackEng` npm registry configured:

```
npm install --save-dev @webcomponents/webcomponentsjs
npm install --save-dev @PaackEng/google-map\#v3.0.3
elm install PaackEng/elm-google-maps
```

You have to import both items (the order matters)

- @webcomponents/webcomponentsjs/custom-elements-es5-adapter
- @PaackEng/google-map

### Example using create-elm-app:

Add those lines in `index.js`

```js
import '@webcomponents/webcomponentsjs/custom-elements-es5-adapter';
import '@PaackEng/google-map';
```

### How to run the example

> Disclaimer: You must install [create-elm-app](https://github.com/halfzebra/create-elm-app)

```
cd examples/ && ELM_APP_GOOGLE_MAP_KEY=your_key elm-app start
```
