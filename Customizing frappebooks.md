## Clone the repository to customize your [frappebooks](https://frappebooks.com/)
```
git clone https://github.com/frappe/books.git
cd books
yarn install
yarn electron:serve or yarn electron:build
```
## ✔ Print Header on every page in frappe books Invoice Template.
```css
@media print {
  .print-on-pages {
    position: fixed;
    page-break-after: always;
  }
}
```

## ✔ Add Custom Fonts

1. Add Font Name in `./tailwind.config.js`
```js
  fontFamily: {
      sans: ['Inter', 'sans-serif', 'Roboto Mono', 'Lexend Peta'],
    },
```
2. Add Font Face in `./src/styles/index.css`
```css
@font-face {
  font-family: 'Roboto Mono';
  font-style: normal;
  font-weight: 400;
  src: url('../assets/fonts/RobotoMono-VariableFont_wght.ttf') format('ttf');
}
```
3. Add Object with font name in `./schemas/app/PrintSettings.json`
```json
{
  "value": "Roboto Mono",
  "label": "Roboto Mono"
},
```
