import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import '@webcomponents/webcomponentsjs/custom-elements-es5-adapter';
import '@google-web-components/google-map';

const flags =
    {}

Elm.Main.init({
    node: document.getElementById('root'),
    flags: process.env.ELM_APP_GOOGLE_MAP_KEY || ""
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
